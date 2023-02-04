<script>
	import ColorSelect from 'svelte-color-select'
    import { fly } from 'svelte/transition'
	import { createEventDispatcher } from 'svelte'
	import { SendNUI } from '@utils/SendNUI'
    import { cart } from '@store/stores'

	const dispatch = createEventDispatcher()
    export let colourMap = {}
    export let optionData = {}
    let r = 1
    let g = 0
    let b = 0
    let hex = ""
    // let paintType = colourMap[0]
    //set paintType to colourMap[0] key
    let paintType = Object.keys(colourMap)[0]
    let colourMode = "rgb"
    let target = "Primary"


    let defaultCols = [
        '#000000',
        '#ffffff',
        '#808080',
        '#ff0000',
        '#00ff00',
        '#0000ff',
        '#ffff00',
        '#ffffff',
        '#00ffff',
        '#ff00ff',
        '#ff8000',
        '#8000ff',
    ]

    let colour = ""
    let colourText = ""


    $: {
        let tempHex = (r << 16) | (g << 8) | b
        //set hex to colour
        hex = "#" + tempHex.toString(16).padStart(6, "0")
    }

    $: {
        //make r,g,b into whole numbers
        r = Math.round(r)
        g = Math.round(g)
        b = Math.round(b)
        //set colour to rgb
        colour = `(${r}, ${g}, ${b})`
        let tempHex = (r << 16) | (g << 8) | b
        //set hex to colour
        hex = "#" + tempHex.toString(16).padStart(6, "0")
        if (colourMode == "hex") {
            colourText = hex
        } else {
            colourText = colour
        }
        let tempData = optionData || {}
            tempData.type = "colour"
            tempData.target = target
            tempData.colour = true
            tempData.customColour = true
            tempData.type = paintType
            tempData.colourValue = {r,g,b}
            SendNUI("PreviewColor", tempData)
            // console.log("PREVIEW CUSTOM PAINT")
    }



</script>





<div
 class="absolute bg-[color:var(--grey)] right-10 bottom-[35rem] w-fit h-fit flex gap-2 flex-col items-center p-0 pb-5 justify-center"
 in:fly={{ x: 50, duration: 150 }}
 >

    <div class="w-full h-[5rem] bg-[color:var(--white)] grid place-items-center" style="background-color: {colour}">
        <p style="color: {hex}" class=" font-text font-bold text-[2rem]">Colour</p>
    </div>

    <ColorSelect bind:r={r} bind:g={g} bind:b={b} />
    <div class="flex gap-2 max-w-full">
        {#each defaultCols as col}
            <button style="background-color: {col}" class="w-[2rem] aspect-square hover:brightness-95" on:click={() => {
                r = parseInt(col.slice(1, 3), 16)
                g = parseInt(col.slice(3, 5), 16)
                b = parseInt(col.slice(5, 7), 16)
            }} />
        {/each}
    </div>
    <!-- create sliders for r,g,b -->
    <div class="flex flex-col gap-2">
        <div class="relative flex flex-row gap-3 w-full">
            <p class="text-[color:var(--white)] font-text font-bold">R</p>
            <input class="slider" type="range" min="0" max="255" bind:value={r} />
        </div>
        <div class="relative flex flex-row gap-3">
            <p class="text-[color:var(--white)] font-text font-bold">G</p>
            <input class="slider" type="range" min="0" max="255" bind:value={g} />
        </div>
        <div class="relative flex flex-row gap-3">
            <p class="text-[color:var(--white)] font-text font-bold">B</p>
            <input class="slider" type="range" min="0" max="255" bind:value={b} />
        </div>
        <div class="relative flex flex-row gap-3">
            <input class="input px-2 font-text font-bold" bind:value={colourText} type="input" min="0" max="255" />
            <select class=" w-[fit] px-2 font-text font-bold focus:outline-none " bind:value={colourMode}>
                <option value="rgb">RGB</option>
                <option value="hex">Hex</option>
            </select>
        </div>
        <div class="relative flex flex-row gap-3">
            <select class="input px-2 font-text font-bold" bind:value={paintType}>
                {#each Object.keys(colourMap) as key}
                    <option value={key}>{key}</option>
                {/each}
            </select>
            <select class="input px-2 font-text font-bold" bind:value={target}>
                    <option value="Primary">Primary</option>
                    <option value="Secondary">Secondary</option>
            </select>
        </div>
        <!-- Cancel and Accept Buttons -->
        <div class="flex flex-row gap-2 w-full">
            <button class="w-full  bg-[color:var(--red)] text-[color:var(--white)] font-text font-bold active:brightness-90 hover:brightness-110"
            on:click={() => {
                dispatch('close')
                SendNUI("ResetVehicle")
            }}
            >
            Cancel
            </button>
            <button class="w-full bg-[color:var(--green)] text-[color:var(--white)] font-text font-bold active:brightness-90 hover:brightness-110"
                on:click={() => {
                    let tempData = optionData || {}
                    tempData.type = "colour"
                    tempData.target = target
                    tempData.colour = true
                    tempData.customColour = true
                    tempData.type = paintType
                    tempData.colourValue = {r,g,b}
                    // console.log(tempData)
                    $cart = [...$cart, tempData]
                    dispatch("purchased")
                    dispatch('close')
                }}
            >
            Apply
            </button>
        </div>
    </div>
</div>


<style>

    .input {
        width: 100%;
    }

    .input:focus {
        outline: none;
    }

    .input::selection {
        background-color: var(--yellow);
        color: var(--black);
    }

    /*********** Baseline, reset styles ***********/
.slider {
  -webkit-appearance: none;
  appearance: none;
  background: transparent;
  cursor: pointer;
  width: 29rem;
}

/* Removes default focus */
.slider:focus {
  outline: none;
}

/******** Chrome, Safari, Opera and Edge Chromium styles ********/
/* slider track */
.slider::-webkit-slider-runnable-track {
  background-color: #000000;
  border-radius: 0rem;
  height: 0.5rem;
}

/* slider thumb */
.slider::-webkit-slider-thumb {
  -webkit-appearance: none; /* Override default look */
  appearance: none;
  margin-top: -4px;
  background-color: var(--yellow);
  border-radius: 0rem;
  height: 1.5rem;
  width: 0.5rem;
}

.slider:focus::-webkit-slider-thumb {
    filter: brightness(200%); 
}


</style>