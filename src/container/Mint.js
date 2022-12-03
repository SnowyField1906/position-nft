import { useEffect, useState } from 'react'
import { utils } from 'ethers'
import { authencation, transactionStatus } from '../provider'
import NFT from '../components/NFT'
import Pool from '../components/Pool'

function Mint(props) {
    const [mintParams, setMintParams] = useState({
        poolID: '',
        tickLower: 0,
        tickUpper: 0,
        amount: 0,
    })

    const [addPoolParams, setAddPoolParams] = useState({
        token0: '',
        token1: '',
        fee: 0,
    })

    console.log(mintParams, addPoolParams)

    const mint = async (pool, tickLower, tickUpper, amount) => {
        console.log(pool)
        await authencation().then(async ({ signer, contractInstance }) => {
            console.log(signer, contractInstance)
            const tx = await contractInstance.mint(
                signer.getAddress(),
                utils.hexlify(pool),
                tickLower,
                tickUpper,
                amount,
                { gasLimit: 1000000 }
            )
            const receipt = await tx.wait()
            try {
                const status = await transactionStatus(tx)
                console.log(status)
            }
            catch (error) {
                console.log(error)
            }
            finally {
                console.log(receipt)
            }
        })
    }

    const addPool = async (token0, token1, fee) => {
        await authencation().then(async ({ signer, contractInstance }) => {
            console.log(signer, contractInstance)
            const tx = await contractInstance.addPool(
                token0,
                token1,
                fee,
                { gasLimit: 1000000 }
            )
            const receipt = await tx.wait()
            try {
            }
            catch (error) {
                console.log(error)
            }
            finally {
                // fetchPools()
                console.log(receipt)
            }
        })
    }

    return (
        <div className='grid'>
            <div className='flex justify-center w-1/3'>
                <NFT params={mintParams} />
            </div>
            <div className='flex justify-center w-2/3'>
                <input type='text' placeholder='poolID' onChange={(e) => setMintParams({ ...mintParams, poolID: e.target.value })} />
                <input type='number' placeholder='tickLower' onChange={(e) => setMintParams({ ...mintParams, tickLower: e.target.value })} />
                <input type='number' placeholder='tickUpper' onChange={(e) => setMintParams({ ...mintParams, tickUpper: e.target.value })} />
                <input type='number' placeholder='amount' onChange={(e) => setMintParams({ ...mintParams, amount: e.target.value })} />
                <button onClick={() => mint(mintParams.poolID, +mintParams.tickLower, +mintParams.tickUpper, +mintParams.amount)}>Mint</button>
            </div>
            <div className='flex justify-center w-2/3'>
                <input type='text' placeholder='token0' onChange={(e) => setAddPoolParams({ ...addPoolParams, token0: e.target.value })} />
                <input type='text' placeholder='token1' onChange={(e) => setAddPoolParams({ ...addPoolParams, token1: e.target.value })} />
                <input type='number' placeholder='fee' onChange={(e) => setAddPoolParams({ ...addPoolParams, fee: e.target.value })} />
                <button onClick={() => addPool(addPoolParams.token0, addPoolParams.token1, +addPoolParams.fee)}>Add Pool</button>
            </div>

        </div >

    )
}

export default Mint
