import { useState } from 'react'
import { authencation, transactionStatus } from '../provider'
import { Signer } from 'ethers'
import NFT from '../components/NFT'

function DayDetail(props) {
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
        <div className='grid'>
            <div className='flex justify-center w-1/3'>
                <NFT params={params} />
            </div>
        </div>
    )
}

export default DayDetail
