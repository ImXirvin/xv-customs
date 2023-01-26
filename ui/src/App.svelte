<script lang="ts">
	import VisibilityProvider from './providers/VisibilityProvider.svelte'
	import { debugData } from './utils/debugData'
	import { browserMode, visibility } from './store/stores'
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import DebugBrowser from './providers/DebugBrowser.svelte'
	import AlwaysListener from './providers/AlwaysListener.svelte'
	import Menu from '@components/Menu.svelte'
	import { dataStore } from '@store/stores';
	import { SendNUI } from '@utils/SendNUI'
	import CamDrag from '@components/CamDrag.svelte'


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
	
	function openSub(e) {
		let data = e.detail
		menuStack.push(currentMenuData)
		currentMenuData = data
		currentIndex = 0
	}

	function backMenu(e) {
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
		<Menu 
		data={currentMenuData}
		showBackButton={menuStack.length > 0}
		bind:currentIndex={currentIndex}
		on:openSub={openSub}
		on:backMenu={backMenu}
	/>
	</div>

		{/key}
	{/if}
</VisibilityProvider>


