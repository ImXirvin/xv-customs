<script>
	import VisibilityProvider from './providers/VisibilityProvider.svelte'
	import { debugData } from './utils/debugData'
	import { browserMode, visibility, resName, cart } from './store/stores'
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import DebugBrowser from './providers/DebugBrowser.svelte'
	import AlwaysListener from './providers/AlwaysListener.svelte'
	import Menu from '@components/Menu.svelte'
	import { dataStore } from '@store/stores';
	import { SendNUI } from '@utils/SendNUI'
	import CamDrag from '@components/CamDrag.svelte'
	import Cart from '@components/Cart.svelte'

	$resName = 'qbx-customs'

	debugData([
		{
			action: 'setVisible',
			data: true,
		},
	])

	debugData([
		{
			action: 'setBrowserMode',
			data: {
				browserMode: true,
			},
		},
	])

	function browserHideAndShow(e) {
		if (e.key === '=') {
			$visibility = !$visibility
		}
	}

	ReceiveNUI('setBrowserMode', (data) => {
		browserMode.set(data.browserMode)
		console.log('browser mode enabled')
		if (data.browserMode) {
			window.addEventListener('keydown', browserHideAndShow)
		} else {
			window.removeEventListener('keydown', browserHideAndShow)
		}
	})


	$: currentMenuData = $dataStore
	let menuStack = []
	let currentIndex = 0
	let showRepairModal = false
	let repairCost = 0
	
	function openSub(e) {
		let data = e.detail
		menuStack.push(currentMenuData)
		currentMenuData = data
		currentIndex = 0
	}

	function backMenu(e) {
		if (showRepairModal) {
			showRepairModal = false
			return
		}
		if (menuStack.length === 0) {
			currentIndex = 0
			SendNUI('hideUI')
			return
		}
		let menu = menuStack.pop()
		let findname = e.detail
		currentMenuData = menu
		currentIndex = menu.options.findIndex((option) => option.name === findname)
	}


	let prevCart = []
	cart.subscribe((cart) => {
		console.log("cart changed UIUIUIUIU")
		// if (prevCart.length !== cart.length) {
		// 	prevCart = cart
			SendNUI('UpdateCart', cart)
		// }
	})

	
</script>

<AlwaysListener />
{#if $browserMode}
	<DebugBrowser />
{/if}

<VisibilityProvider>
	{#if currentMenuData.options}
	{#key currentMenuData.options}
	<div class="flex flex-col w-full h-full">
		<CamDrag />
		<Cart />
		<Menu 
		data={currentMenuData}
		showBackButton={menuStack.length > 0}
		bind:currentIndex={currentIndex}
		on:openSub={openSub}
		on:backMenu={backMenu}
		on:repairVehicleModal={(e) => {
			let cost = e.detail
			showRepairModal = true
			repairCost = cost
			// console.log(e)
		}}
		/>
		{#if showRepairModal}
			<div class="fixed top-0 left-0 w-full h-full bg-black bg-opacity-50 z-50 flex justify-center items-center">
				<div class="bg-[color:var(--grey)]  p-4">
					<h1 class="text-5xl text-white">Repair Vehicle</h1>
					<p class="text-white">Are you sure you want to repair your vehicle for?</p>
					<!-- show repair cost here -->
					<p class="w-full text-center bg-[color:var(--white)] justify-self-center text-[color:var(--black)] font-text font-bold text-[2rem] px-2">
						${repairCost}
					</p>
					<div class="flex justify-end mt-4 gap-2">
						<button 
						class="w-full  bg-[color:var(--red)] text-[color:var(--white)] font-text font-bold active:brightness-90 hover:brightness-110"
							on:click={() => showRepairModal = false}>Cancel</button>
						<button 
							class="w-full bg-[color:var(--green)] text-[color:var(--white)] font-text font-bold active:brightness-90 hover:brightness-110" 
							on:click={() => {
							showRepairModal = false
							SendNUI('RepairVehicle')
						}}>Repair</button>
					</div>
				</div>
			</div>
		{/if}
	</div>

		{/key}
	{/if}
</VisibilityProvider>


