import { useState, useEffect } from 'react'
import { monthNames, pixelConfig } from '../constants'

import { authencation, transactionStatus } from '../provider/index'

function Pixels(props) {
	const isLeap = (year) => new Date(year, 1, 29).getDate() === 29
	const isToday = (year, month, day) => {
		const today = new Date()
		return today.getFullYear() === year && today.getMonth() === month && today.getDate() === day + 1
	}
	const isPicking = (i, j) => {
		return props.picking.month === i && props.picking.day === j
	}

	const handlePixel = (i, j) => {
		props.setPicking({ ...props.picking, month: i, day: j })
		props.setForm({ mood: 0, weather: 0, emotion: 0, journal: '' })
	}


	const handleRing = (i, j) => {
		return isToday(props.picking.year, i, j) && isPicking(i, j) ? "overlap"
			: isToday(props.picking.year, i, j) ? "today"
				: isPicking(i, j) ? "choosing"
					: "default"
	}

	console.log(transactionStatus)

	const [loading, setLoading] = useState(true)
	const monthDays = [31, 28 + isLeap(props.picking.year), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	var count = -1

	const [pixels, setPixels] = useState([])

	useEffect(() => { 
		setLoading(true)
		const exactMood = async () => {
			return new Promise(async (resolve, reject) => {
				try {
					count = -1
					const date = Math.ceil(new Date(props.picking.year, 0, 1).getTime() / 86400000)
					await authencation().then(async ({ signer, contractInstance }) => {
						const result = await contractInstance.viewMood(
							date,
							date + 365 + isLeap(props.picking.year),
							signer.getAddress()
						)
						resolve(result)
					})
				} catch {
					reject(false)
				} finally {
					setLoading(false)
					console.log('Loaded all pixels')
				}
			})
		}
		exactMood().then((mood) => { setPixels(mood) })
	}, [props.picking.year])

	return (
		<>
			<div className={loading ? "hidden" : "flex"}>
				<div className="grid overflow-hidden grid-cols-1 auto-rows-auto gap-x-1 gap-y-1 place-content-start place-items-right mt-7 mr-2">
					{
						[...Array(31)].map((_, i) => {
							return (
								<div class="text-black text-right text-xs h-4">{(i + 1) % 2 === 0 ? (i + 1) : ""}</div>
							)
						})
					}
				</div>

				<div class="grid overflow-hidden grid-cols-12 grid-rows-1 gap-x-1 gap-y-1">
					{
						[...Array(12)].map((_, i) => {
							return (
								<div class="grid overflow-hidden grid-cols-1 auto-rows-auto place-content-start place-items-center">
									<p className="text-center px-1.5">{monthNames[i].slice(0, 3)}</p>
									{
										[...Array(monthDays[i])].map((_, j) => {
											count++
											return (
												<div className={
													`my-[2px] mx-[1px] rounded-sm w-[87%] h-4 cursor-pointer 
													${pixelConfig[pixels[count] === 0
														? (+isPicking(i, j) * props.form.mood)
														: pixels[count]]}
                          							${pixelConfig[handleRing(i, j)]}`}
													onClick={() => handlePixel(i, j)}>
												</div>
											)
										})
									}
								</div>
							)
						})
					}
				</div>

 
			</div >

			{loading &&
				<div className="flex justify-center items-center h-screen">
					<div className="animate-spin rounded-full h-20 w-20 border-t-2 border-b-2 border-blue-600"></div>
				</div>
			}
		</>

	)

}

export default Pixels