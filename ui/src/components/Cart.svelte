<script>
	import { SendNUI } from '@utils/SendNUI'
	import { fly } from 'svelte/transition'
	import { cart, isCart } from '@store/stores'

	let total = 0
	$: total = $cart.reduce((acc, item) => acc + item.price, 0)

	let buyModal = false
</script>

{#if $isCart}
	<div
		class="absolute bg-[color:var(--grey)] left-10 bottom-[35rem] w-[35rem] h-[50rem] flex gap-2 flex-col items-center p-0 pb-5 justify-start"
		in:fly={{ x: 50, duration: 150 }}
	>
		<div
			class="w-full h-[5rem] grid place-items-center bg-[color:var(--yellow)]"
		>
			<p class=" font-text font-bold text-[2rem]">Cart</p>
			<button
				class="absolute top-0 right-0 aspect-square h-[3rem] bg-[color:var(--red)] focus:outline-none text-[color:var(--white)] font-text text-center font-bold active:brightness-90 hover:brightness-110 grid place-items-center p-1"
				on:click={() => ($isCart = false)}
			>
				<i class="fa-solid fa-times" />
			</button>
		</div>

		<div
			class="flex flex-col w-full h-full gap-2 px-5 py-3 overflow-x-hidden overflow-y-scroll scrollbar-hide"
		>
			{#each $cart as item, i}
				<div
					class="flex flex-row w-full min-h-[5rem] bg-[color:var(--white)] items-center p-5 gap-5"
				>
					<button
						class="grid place-items-center bg-[color:var(--red)] active:brightness-90 hover:brightness-110 text-[color:var(--white)] w-[2rem] relative h-[2rem] aspect-square"
						on:click={() => {
							$cart.splice(i, 1)
							$cart = [...$cart]
						}}
					>
						<i class="fa-solid fa-times" />
					</button>
					<div
						class="flex flex-col w-1/2 h-full justify-center items-center"
					>
						{#if item.colour}
							<div
								class="font-text font-bold text-[1.5rem] text-start w-full"
							>
								{item.target} | {item.name} | {item.type}
							</div>
						{:else}
							<p
								class="font-text font-bold text-[1.5rem] text-start w-full"
							>
								{item.parent} | {item.name}
							</p>
						{/if}
					</div>
					<div
						class="flex flex-col w-1/2 h-full justify-center items-center"
					>
						<p
							class="font-text font-bold text-[1.5rem] text-end w-full"
						>
							${item.price}
						</p>
					</div>
				</div>
			{/each}
		</div>

		<div class="flex flex-row gap-2 w-full px-5">
			<button
				class="w-full bg-[color:var(--green)] text-[color:var(--white)] font-text font-bold active:brightness-90 hover:brightness-110"
				on:click={() => {
					buyModal = true
				}}
			>
				Buy
			</button>
			<p
				class="w-full bg-[color:var(--white)] text-[color:var(--black)] text-end font-text font-bold text-[2rem] px-2"
			>
				${total}
			</p>
		</div>
	</div>
{/if}

{#if buyModal}
	<div
		class="fixed top-0 left-0 w-full h-full bg-black bg-opacity-50 z-50 flex justify-center items-center"
	>
		<div class="bg-[color:var(--grey)]  p-4">
			<h1 class="text-5xl text-white">Buy Cart</h1>
			<p class="text-white">
				Are you sure you want to buy these items?
			</p>
			<!-- show repair cost here -->
			<p
				class="w-full text-center bg-[color:var(--white)] justify-self-center text-[color:var(--black)] font-text font-bold text-[2rem] px-2"
			>
				${total}
			</p>
			<div class="flex justify-end mt-4 gap-2">
				<button
					class="w-full  bg-[color:var(--red)] text-[color:var(--white)] font-text font-bold active:brightness-90 hover:brightness-110"
					on:click={() => (buyModal = false)}>Cancel</button
				>
				<button
					class="w-full bg-[color:var(--green)] text-[color:var(--white)] font-text font-bold active:brightness-90 hover:brightness-110"
					on:click={() => {
						buyModal = false
						SendNUI('PurchaseCart', $cart)
					}}>BUY</button
				>
			</div>
		</div>
	</div>
{/if}
