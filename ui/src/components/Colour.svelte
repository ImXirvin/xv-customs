<script>
	import ColorSelect from 'svelte-color-select'
    import { fly } from 'svelte/transition'
	import { createEventDispatcher } from 'svelte'

	const dispatch = createEventDispatcher()


    let r = 1
    let g = 0
    let b = 0


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
    $: {
        let hex = (r << 16) | (g << 8) | b
        //set hex to colour
        colour = "#" + hex.toString(16).padStart(6, "0")
    }

    let textCol = ""
    $: {
        let hex = (255 - r << 16) | (255 - g << 8) | (255 - b)
        //set hex to colour
        textCol = "#" + hex.toString(16).padStart(6, "0")
    }
</script>





<div
 class="absolute bg-[color:var(--grey)] right-10 bottom-[35rem] w-fit h-fit flex gap-2 flex-col items-center p-0 pb-5 justify-center"
 in:fly={{ x: 50, duration: 150 }}
 >

    <div class="w-full h-[5rem] bg-[color:var(--white)] grid place-items-center" style="background-color: {colour}">
        <p style="color: {textCol}" class=" font-text font-bold">Colour</p>
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
            <input class="input px-2 font-text font-bold" bind:value={colour} type="input" min="0" max="255" />
        </div>
        <!-- Cancel and Accept Buttons -->
        <div class="flex flex-row gap-2 w-full">
            <button class="w-full  bg-[color:var(--red)] text-[color:var(--white)] font-text font-bold hover:brightness-90 active:brightness-110"
            on:click={() => {
                dispatch('close')
            }}
            >
            Cancel
            </button>
            <button class="w-full bg-[color:var(--green)] text-[color:var(--white)] font-text font-bold hover:brightness-90 active:brightness-110"
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