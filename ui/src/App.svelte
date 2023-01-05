<script lang="ts">
	import VisibilityProvider from './providers/VisibilityProvider.svelte'
	import { debugData } from './utils/debugData'
	import { browserMode, visibility } from './store/stores'
	import { ReceiveNUI } from './utils/ReceiveNUI'
	import DebugBrowser from './providers/DebugBrowser.svelte'
	import AlwaysListener from './providers/AlwaysListener.svelte'

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
			$visibility = true
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
</script>

<VisibilityProvider>
	<!-- PUT STUFF HERE  -->
</VisibilityProvider>

<AlwaysListener />
{#if $browserMode}
	<DebugBrowser />
{/if}
