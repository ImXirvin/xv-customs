<script>
	import { debugData } from '@utils/debugData'

	let dummyData = {
		name: 'Menu',
		options: [
			{
				name: 'Customisations',
				icon: "bi bi-car-front-fill",
				options: [
					//ENGINE
					{
						name: 'Engine',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					//BRAKES
					{
						name: 'Brakes',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					//TRANSMISSION
					{
						name: 'Transmission',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					//SUSPENSION
					{
						name: 'Suspension',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					//ARMOUR
					{
						name: 'Armour',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					//TURBO
					{
						name: 'Turbo',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
				],
			},
			{
				name: 'Cosmetics',
				icon: "fa-solid fa-wand-magic-sparkles",
				options: [
					{
						name: 'Window Tint',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					{
						name: 'Neon',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					{
						name: 'Tyre Smoke',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					{
						name: 'Livery',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					{
						name: 'Plate',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
						],
					},
				],
			},
			{
				name: 'Colours',
				icon: "fas fa-palette",
				options: [
					{
						name: 'Primary',
					},
					{
						name: 'Secondary',
					},
					{
						name: 'Pearlescent',
					},
					{
						name: 'Wheel',
					},
					{
						name: 'Dashboard',
					},
					{
						name: 'Trim',
					},
					{
						name: 'Neon',
					},
					{
						name: 'Tyre Smoke',
					},
				],
			},
			{
				name: 'Wheels',
				options: [
					{
						name: 'Wheel Type',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
					{
						name: 'Wheel Accessory',
						options: [
							{
								price: 0,
								mod: 1,
							},
							{
								price: 1000,
								mod: 2,
							},
							{
								price: 2000,
								mod: 3,
							},
							{
								price: 3000,
								mod: 4,
							},
							{
								price: 4000,
								mod: 5,
							},
							{
								price: 5000,
								mod: 6,
							},
							{
								price: 6000,
								mod: 7,
							},
						],
					},
				],
			},
			{
				name: 'Metal',
				action: 'colour',
				colour: true,
				options: [
					{
						name: "Brushed Steel",
					}
				]
			},
		],
	}

	// debugData(
	// 	[
	// 		{
	// 			action: 'setData',
	// 			data: dummyData,
	// 		},
	// 	],
	// 	0
	// )
</script>
