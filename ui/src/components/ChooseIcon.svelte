<script>
	import Icons from './Icons.svelte'
	import { icons } from './icons'

    export let item = {}
    export let currentIndex
    export let data = {}
    export let i = 0
function findSuitableIcon(name) {
        //find first word in name
        let firstWord = name.split(' ')[0]

        if (icons[firstWord]) {
            return firstWord
        }
        //add s to end of word
        if (icons[firstWord + 's']) {
            return firstWord + 's'
        }

        //remove s from end of word
        if (icons[firstWord.slice(0, -1)]) {
            return firstWord.slice(0, -1)
        }

        //get second word in name
        let secondWord = name.split(' ')[1]
        if (secondWord) {
            if (icons[secondWord]) {
                return secondWord
            }

            //add s to end of word
            if (icons[secondWord + 's']) {
                return secondWord + 's'
            }

            //remove s from end of word
            if (icons[secondWord.slice(0, -1)]) {
                return secondWord.slice(0, -1)
            }
        }

        return "bi bi-car-front-fill"
    }

</script>


				{#if item.icon}
                {#if icons[item.icon]}
                    <Icons
                        name={item.icon}
                        height="h-[5rem]"
                        width="h-[5rem]"
                        class="absolute top-1/2 left-1/2 -translate-x-1/2 transition-transform -translate-y-1/2 {i ==
                        currentIndex
                            ? 'scale-150'
                            : ''}"
                    />
                {:else}
                    <i
                        class="{item.icon} text-[5rem] absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
                    />
                {/if}
            {:else if icons[item.name]}
                <Icons
                    name={item.name}
                    height="h-[5rem]"
                    width="h-[5rem]"
                    class="absolute top-1/2 left-1/2 -translate-x-1/2 transition-transform -translate-y-1/2 {i ==
                    currentIndex
                        ? 'scale-150'
                        : ''}"
                />
            {:else if icons[data.icon]}
                <Icons
                    name={data.icon}
                    height="h-[5rem]"
                    width="h-[5rem]"
                    class="absolute top-1/2 left-1/2 -translate-x-1/2 transition-transform -translate-y-1/2 {i ==
                    currentIndex
                        ? 'scale-150'
                        : ''}"
                />
            {:else if data.icon}
                <i
                    class="{data.icon} text-[5rem] absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
                />
            {:else if icons[data.name]}
                <Icons
                    name={data.name}
                    height="h-[5rem]"
                    width="h-[5rem]"
                    class="absolute top-1/2 left-1/2 -translate-x-1/2 transition-transform -translate-y-1/2 {i ==
                    currentIndex
                        ? 'scale-150'
                        : ''}"
                />
            {:else}
                {#if icons[findSuitableIcon(data.name)]}
                    <Icons
                        name={findSuitableIcon(data.name)}
                        height="h-[5rem]"
                        width="h-[5rem]"
                        class="absolute top-1/2 left-1/2 -translate-x-1/2 transition-transform -translate-y-1/2 {i ==
                        currentIndex
                            ? 'scale-150'
                            : ''}"
                    />
                {:else}
                    <i
                        class="{findSuitableIcon(data.name)} text-[5rem] absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
                    />
                {/if}
            {/if}