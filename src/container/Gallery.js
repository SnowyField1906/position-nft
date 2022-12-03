import { useState, useEffect } from 'react'

import { authencation } from '../provider'

import Pool from '../components/Pool'

function Gallery(props) {
	const [numberOfNFTs, setNumberOfNFTs] = useState(0)
	const [nfts, setNFTs] = useState([])

	useEffect(() => {
		fetchPools()
	}, [])

	const [pools, setPools] = useState({})

	const fetchNFTs = async () => {
		await authencation()
			.then(async ({ _, contractInstance }) => {
				await contractInstance.nextTokenID().then((nextTokenID) => {
					setNumberOfNFTs(nextTokenID.toNumber());
				});
				let nfts = [];
				for (let i = 0; i < numberOfNFTs; i++) {
					await contractInstance.nftInfo(i).then((nft) => {
						nfts.push(nft);
					});
				}
				setNFTs(nfts);
			})
	}

	const fetchPools = async () => {
		await authencation()
			.then(async ({ _, contractInstance }) => {
				await contractInstance.availablePools().then((availablePools) => {
					availablePools.forEach((pool) => {
						contractInstance.poolInfo(pool).then((info) => {
							setPools({ ...pools, [pool]: info })
						})
					})
				});
				setPools(pools)
			})
	}

	useEffect(() => {
		fetchNFTs();
	}, [numberOfNFTs]);

	return (
		<div className="flex flex-col items-center justify-center w-full h-full">
			{nfts.length && nfts.map((nft) => {
				return (
					<div className="flex flex-col items-center justify-center w-1/3 h-full">
						<div>owner: {nft[0]}</div>
						<div>tickLower: {nft[1]}</div>
						<div>tickUpper: {nft[2]}</div>
						<div>amount: {nft[3]}</div>
						<div>pool: {nft[4]}</div>
					</div>
				)
			})}
			<div className='flex justify-center w-2/3'>
				{
					Object.keys(pools).length ? <div className='flex justify-center w-2/3'>
						{Object.keys(pools).map((pool) => (
							<Pool id={pool} info={pools[pool]} />
						))}
					</div>
						: <div>Loading...</div>
				}
			</div>
		</div>
	)
}

export default Gallery