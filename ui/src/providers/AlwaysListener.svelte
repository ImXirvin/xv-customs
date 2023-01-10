<script lang="ts">
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { dataStore } from '@store/stores';

	ReceiveNUI('setData', (data) => {
		// console.log('setData')
		console.log("Data Received: ", data)
		dataStore.set(data)
	})


</script>
