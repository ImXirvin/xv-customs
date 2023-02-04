<script>
	import { fly } from 'svelte/transition'
	import { createEventDispatcher, onDestroy, onMount } from 'svelte'
	import Colour from './Colour.svelte'
	import ChooseIcon from './ChooseIcon.svelte'
	import { colours } from './colours'
	import { SendNUI } from '@utils/SendNUI'
	import { cart, isCart } from '@store/stores'

	const dispatch = createEventDispatcher()
	let menuElement = null

	export let data = {}
	export let showBackButton = false
	export let currentIndex = 0

	let purchased = false
	let originalItem = null
	let choosingColour = false
	onMount(() => {
		// console.log(data)
		// document.addEventListener('wheel', Listener)
		// document.addEventListener('keydown', Listener)
		//add event listener for mouse wheel and arrow keys for menuElement
		menuElement.addEventListener('wheel', Listener)
		document.addEventListener('keydown', Listener)

		// getParentMenuName("Cosmetics")

		if (data.options) {
			// console.log("NAME", data.name)
			data.options.forEach((item, i) => {
				if (item.selected) {
					currentIndex = i
					if (originalItem == null) {
						originalItem = item
					}
				}
			})
		}
	})

	onDestroy(() => {
		document.removeEventListener('wheel', Listener)
		document.removeEventListener('keydown', Listener)
	})

	function Listener(e) {
		if (choosingColour) return
		if (inSearch) return
		//check for mouse wheel event
		if (e.type == 'wheel') {
			//scroll down
			if (e.deltaY > 0) {
				if (currentIndex < data.options.length - 1) {
					currentIndex += 1
				}
			}
			//scroll up
			else {
				if (currentIndex > 0) {
					currentIndex -= 1
				}
			}
		}
		//check for arrow keys
		if (e.type == 'keydown') {
			if (e.key == 'ArrowLeft') {
				if (currentIndex > 0) {
					currentIndex -= 1
				}
			} else if (e.key == 'ArrowRight') {
				if (currentIndex < data.options.length - 1) {
					currentIndex += 1
				}
			}

			if (e.key == 'Enter') {
				selectOption(currentIndex, data.options[currentIndex])
			}

			if (e.key == 'Escape') {
				backMenu()
			} else if (e.key == 'Backspace') {
				backMenu()
			}
		}
	}

	function selectOption(index, option) {
		if (option.selected && !option.options) return
		if (choosingColour) return
		if (option.options) {
			dispatch('openSub', option)
			return
		}
		if (option.modIndex) {
			let isAlreadyInCart = $cart.some((item) => item.name == option.name)
			if (isAlreadyInCart) return

			let prev = $cart.some((item) => item.modSlot == option.modSlot)
			if (prev) {
				//remove previous mod
				cart.update((n) => {
					let temp = n.filter(
						(item) => item.modSlot != option.modSlot
					)
					return temp
				})
			}

			let tempData = data.options[index]
			tempData.parent = data.name
			cart.update((n) => {
				n.push(tempData)
				return n
			})
			purchased = true
			return
		}
		if (option.customColour) {
			choosingColour = true
			return
		}

		if (option.colour) {
			let tempData = data.options[index]
			tempData.parent = data.name
			tempData.type = data.name
			tempData.target = data.target
			tempData.colour = true
			// console.log(tempData)
			let isSameTarget = $cart.some(
				(item) => item.target == tempData.target
			)
			if (isSameTarget) {
				let isAlreadyInCart = $cart.some(
					(item) => item.name == option.name
				)
				if (isAlreadyInCart) return
				//remove previous mod
				cart.update((n) => {
					let temp = n.filter(
						(item) => item.target != tempData.target
					)
					return temp
				})
			}
			$cart = [...$cart, tempData]
			purchased = true
			return
		}

		if (option.name == 'Repair') {
			// SendNUI('RepairVehicle')
			// console.log('repair vehicle', data)
			dispatch('repairVehicleModal', option.price)
			return
		}
	}

	function backMenu() {
		//check if current menu has indexes with modIndex using some


		let hasModIndex = data.options.some((item) => item.modIndex)
		let hasColour = data.options.some((item) => item.colour)
		if (!purchased && (hasModIndex || hasColour)) {
			SendNUI('ResetVehicle')
		}
		dispatch('backMenu', data.name)
	}

	let ColourMap = {
		Classic: colours.classicMetallic,
		Metallic: colours.classicMetallic,
		Matte: colours.matte,
		Metal: colours.metal,
		Chrome: colours.chrome,
		Pearlescent: colours.classicMetallic,
	}

	let oldIndex = null
	$: {
		if (currentIndex != oldIndex) {
			oldIndex = currentIndex
			if (data.options[currentIndex].modIndex) {
				SendNUI('PreviewChange', data.options[currentIndex])
				// console.log('mod change')
			}

			if (data.colour) {
				let tempData = data.options[currentIndex]
				tempData.type = data.name
				tempData.target = data.target
				tempData.colour = true
				SendNUI('PreviewColor', tempData)
				// console.log("colour change", tempData)
			}
		}
	}

	let search = ''
	let searchResults = []
	let inSearch = false
	$: {
		if (search.length > 0) {
			searchResults = data.options.filter((item) => {
				return item.name.toLowerCase().includes(search.toLowerCase())
			})
		} else {
			searchResults = data.options
		}
	}
</script>

<div
	bind:this={menuElement}
	in:fly={{ x: 50, duration: 150 }}
	class="w-full absolute h-[35rem] bottom-0 flex flex-col p-5 gap-5"
>
	<div class="flex flex-row gap-2 mx-9">
		{#if showBackButton}
			<button
				class="bg-[color:var(--black)] aspect-square grid place-items-center hover:brightness-95 text-[2.5rem] text-white"
				on:click={() => {
					backMenu()
				}}
			>
				<i class="fas fa-chevron-left" />
			</button>
		{/if}
		<div
			class="bg-[color:var(--black)] cursor-pointer  text-white w-fit h-fit p-3 text-[2rem] font-text uppercase font-bold flex flex-row gap-3 items-center justify-center"
		>
			<p>{data.name}</p>
			<div
				class="min-w-[6rem] h-full bg-[color:var(--white)] text-[2rem] text-[color:var(--black)] text-center gap-0"
			>
				{currentIndex + 1}/{data.options.length}
			</div>
		</div>
		<div
			class="bg-[color:var(--black)] cursor-pointer  text-white w-fit h-fit p-3 text-[2rem] font-text uppercase font-bold flex flex-row gap-3 items-center justify-center"
		>
			<p>SEARCH</p>
			<input
				class="w-[10rem] h-full focus:outline-none bg-[color:var(--white)] text-[2rem] text-[color:var(--black)]"
				type="text"
				bind:value={search}
				on:focusin={() => (inSearch = true)}
				on:focusout={() => (inSearch = false)}
			>
		</div>
		<div
			class="bg-[color:var(--black)] cursor-pointer  text-white w-fit h-fit p-3 text-[2rem] font-text uppercase font-bold flex flex-row gap-3 items-center justify-center"
			on:click={() => ($isCart = !$isCart)}
		>
			<i class="fa-solid fa-cart-shopping" />
			<div
				class="w-[3rem] h-full bg-[color:var(--white)] text-[2rem] text-[color:var(--black)] text-center gap-0"
			>
				{$cart.length}
			</div>
		</div>
	</div>

	<div
		style="left: calc(-30rem * {currentIndex});"
		class="h-[20rem] w-screen flex flex-row relative overflow-visible gap-4 box-border options-container px-5"
	>
		{#each searchResults as item, i}
			<div
				class="w-[29rem] relative h-[18rem] 
            selected{i == currentIndex ? ' scale-110 mx-10' : '-not'} 
            flex-shrink-0 option cursor-pointer active:brightness-90 hover:brightness-110"
				on:click={() => {
					if (choosingColour) return
					// console.log("click")
					if (i == currentIndex) {
						selectOption(i, item)
						return
					}
					currentIndex = i
				}}
			>
				{#if item.price != undefined}
					<span
						class="w-fit h-fit px-2 py-1 price-tag top-0 right-0 absolute font-bold font-text price-trans"
					>
						${item.price}
					</span>
				{/if}
				{#if item.selected == true}
					<span
						class="w-fit h-fit aspect-square p-3 already-use font-bold font-text price-trans grid place-items-center"
					>
						<i class="fas fa-check" />
					</span>
				{/if}
				<!-- check if item is in cart if so then show a cart icon -->
				{#if $cart.find((cartItem) => {
					// console.log(cartItem)
					if (data.colour == true) {
						return cartItem.num == item.num && cartItem.type == data.name
					}
					return cartItem.name == item.name && cartItem.parent == data.name
				})}
					<span
						class="w-fit h-fit aspect-square p-3 already-use font-bold font-text price-trans grid place-items-center"
					>
						<i class="fas fa-cart-shopping" />
					</span>
				{/if}

				{#if data.colour == true}
					<div
						class="w-[20rem] h-[10rem] left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 absolute"
						style="background-color: {ColourMap[data.name]
							? ColourMap[data.name][item.name]
							: 'rgb(0, 0, 0, 0)'}; "
					/>
				{:else}
					<ChooseIcon {item} {currentIndex} {data} {i} />
				{/if}

				<span
					class="w-full leading-8 h-fit absolute bottom-0 text-[2rem] py-2 text-trans {i ==
					currentIndex
						? ' font-bold tracking-widest text-[2.2rem] '
						: ''} text-center font-semibold font-text"
				>
					{#if item.name}
						{item.name}
					{:else}
						{data.name} {item.mod}
					{/if}
				</span>
			</div>
		{/each}
	</div>
</div>

{#if choosingColour}
	<Colour
		optionData={data.options[currentIndex]}
		colourMap={ColourMap}
		on:close={() => (choosingColour = false)}
		on:purchased={() => (purchased = true)}
	/>
{/if}

<style>
	.option {
		transition: all 150ms ease-in-out;
	}

	.selected {
		background-color: var(--yellow);
		color: var(--black);
	}
	.selected > .price-tag,
	.selected > .already-use {
		background-color: var(--green);
		color: var(--white);
	}
	.selected-not {
		background-color: var(--grey);
		color: var(--white);
	}
	.selected-not > .price-tag,
	.selected-not > .already-use {
		background-color: var(--black);
		color: var(--white);
	}
</style>
