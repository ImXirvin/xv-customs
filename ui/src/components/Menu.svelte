<script>
	import { fly } from 'svelte/transition'
	import { createEventDispatcher, onDestroy, onMount } from 'svelte'
    import Colour from './Colour.svelte';
	import ChooseIcon from './ChooseIcon.svelte'
	import { colours } from './colours';
	import { SendNUI } from '@utils/SendNUI'

	const dispatch = createEventDispatcher()


	export let data = {}
    export let showBackButton = false
	export let currentIndex = 0

	let purchased = false
	let originalItem = null
    let choosingColour = false
    onMount(() => {
        // console.log(data)
        document.addEventListener('wheel', Listener)
        document.addEventListener('keydown', Listener)
        // getParentMenuName("Cosmetics")

		if (data.options) {
			console.log("NAME", data.name)
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
		if (!purchased) {
			SendNUI("ResetVehicle")
		}
    })


	function Listener(e) {
        if (choosingColour) return
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
        if (choosingColour) return
		if (option.options) {
			dispatch('openSub', option)
		}
        if (option.modIndex) {
            console.log("action")
        }

		// if (data.colour) {

		// }
        // if (option.colour) {
        //     choosingColour = true
        // }
		currentIndex = index
	}

    function backMenu() {
        dispatch('backMenu', data.name)
    }


	let ColourMap = {
		"Classic": colours.classicMetallic,
		"Metallic": colours.classicMetallic,
		"Matte": colours.matte,
		"Metal": colours.metal,
		"Chrome": colours.chrome,
		"Pearlescent": colours.classicMetallic,
	}

	let oldIndex = null
	$: {
		if (currentIndex != oldIndex) {
			oldIndex = currentIndex
			if (data.options[currentIndex].modIndex) {
				SendNUI("PreviewChange", data.options[currentIndex])
				console.log("mod change")
			}

			if (data.colour) {
				let tempData = data.options[currentIndex]
				tempData.type = data.name
				tempData.target = data.target
				tempData.colour = true
				SendNUI("PreviewChange", tempData)
				console.log("colour change", tempData)
			}
			// console.log(data.options)
		}
	}


</script>

<div
	in:fly={{ x: 50, duration: 150 }}
	class="w-full absolute h-[35rem] bottom-0 flex flex-col p-5 gap-5"
>   
    <div class="flex flex-row gap-2 mx-9">
        {#if showBackButton}
        <button 
        class="bg-[color:var(--black)] aspect-square grid place-items-center hover:brightness-95 text-[2.5rem] text-white"
        on:click={
            () => {
                backMenu()
            }
        }
        >
            <i class="fas fa-chevron-left" />
        </button>
        {/if}
        <div
		class="bg-[color:var(--black)] cursor-pointer  text-white w-fit h-fit p-3 text-[2rem] font-text uppercase font-bold flex flex-row gap-3 items-center justify-center"
	>
		<p>{data.name}</p>
		<div
			class="w-[5rem] h-full bg-[color:var(--white)] text-[2rem] text-[color:var(--black)] text-center gap-0"
		>
			{currentIndex + 1}/{data.options.length}
		</div>
	</div>
    </div>


	<div
		style="left: calc(-30rem * {currentIndex});"
		class="h-[20rem] w-screen flex flex-row relative overflow-visible gap-4 box-border options-container px-5"
	>
		{#each data.options as item, i}
			<div
				class="w-[29rem] relative h-[18rem] 
            selected{i == currentIndex ? ' scale-110 mx-10' : '-not'} 
            flex-shrink-0 option cursor-pointer hover:brightness-90 active:brightness-110"
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
				{#if (data.colour == true)}
					<div 
						class="w-[20rem] h-[10rem] left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 absolute"
						
						style="background-color: {ColourMap[data.name]? ColourMap[data.name][item.name] : "rgb(0, 0, 0, 0)"}; " 
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
    <Colour on:close={()=>choosingColour=false}/>
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
