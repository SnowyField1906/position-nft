import { useState } from 'react'
import { authencation, transactionStatus } from '../provider'
import { Signer } from 'ethers'
import NFT from '../components/NFT'

function Mint(props) {
    const [params, setParams] = useState({
        pool: '',
        tickLower: 0,
        tickUpper: 0,
        fee: 0
    })
    const mint = async (pool, tickLower, tickUpper, fee) => {
        await authencation()
            .then(async ({ signer, contractInstance }) => {
                console.log(signer, contractInstance)
                contractInstance.mint(pool, signer.getAddress(), tickLower, tickUpper, fee, { gasLimit: 3000000 })
                const tx = await contractInstance.create();
                const receipt = await tx.wait()
                try {
                    const status = await transactionStatus(tx)
                    console.log(status)
                }
                catch (error) {
                    console.log(error)
                }
                finally {
                    // props.setPicking({ ...props.picking, year: props.picking.year })
                    console.log(receipt)
                }
            })
    }

    return (
        <div className='flex'>
            <div className='flex justify-center w-1/3'>
                <NFT params={params} />
            </div>
            <div className='flex justify-center w-2/3'>
                <input type='text' placeholder='pool' onChange={(e) => setParams({ ...params, pool: e.target.value })} />
                <input type='text' placeholder='tickLower' onChange={(e) => setParams({ ...params, tickLower: e.target.value })} />
                <input type='text' placeholder='tickUpper' onChange={(e) => setParams({ ...params, tickUpper: e.target.value })} />
                <input type='text' placeholder='fee' onChange={(e) => setParams({ ...params, fee: e.target.value })} />
                <button onClick={() => mint(params.pool, params.tickLower, params.tickUpper, params.fee)}>Mint</button>
            </div>
        </div>
    )
}

export default Mint
