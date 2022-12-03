import React from 'react'

function Pool({ id, info }) {
    return (
        <div className='rounded-md w-2/3 h-full'>
            <div className='flex text-sm'>Pool address: {id}</div>
            <div className='p-4 border border-white/50 border-rounded-md'>
                First token: {info[0]}
            </div>
            <div className='p-4 border border-white/50 border-rounded-md'>
                Second token: {info[1]}
            </div>
            <div className='p-4 border border-white/50 border-rounded-md'>
                Fee: {info[2]}
            </div>
        </div>
    )
}

export default Pool
