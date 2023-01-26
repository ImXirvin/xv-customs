<script lang="ts">
	import { SendNUI } from '@utils/SendNUI'

	let isMouseDown = false

	let moveHandler = (e: MouseEvent) => {
		// console.log(e.movementX)
		let moveX = e.movementX
		let moveY = e.movementY
		// let x = moveX > 0 ? (moveX > 10 ? 10 : moveX) : (moveX < -10 ? -10 : moveX)
		// let y = moveY > 0 ? (moveY > 10 ? 10 : moveY) : (moveY < -10 ? -10 : moveY)
		let x = moveX / 8
		let y = moveY / 8
		SendNUI('move', { x: x, y: y })
	}
	let scrollHandler = (e: WheelEvent) => {
		// console.log(e.deltaX, e.deltaY)
		let y = e.deltaY > 0 ? 0.5 : -0.5
		SendNUI('zoom', y)
	}
</script>




<div class={`w-full h-full ${isMouseDown?"cursor-grabbing":"cursor-grab"}`}
    on:mousedown={() => isMouseDown = true}
    on:mouseup={() => isMouseDown = false}
    on:wheel={scrollHandler}
    on:mousemove={isMouseDown?moveHandler:null}
>
</div>