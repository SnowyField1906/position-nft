import { authencation, transactionStatus } from '../provider/index'

import { monthNames } from '../constants'

import Amazing from '../svgs/Amazing'
import Average from '../svgs/Average'
import Difficult from '../svgs/Difficult'
import Great from '../svgs/Great'
import Tough from '../svgs/Tough'

function DayDetail(props) {
    const addMood = async (date, mood) => {
        await authencation()
            .then(async ({ signer, contractInstance }) => {
                console.log(signer, contractInstance)
                contractInstance.addMood(date, mood, signer.getAddress(), { gasLimit: 3000000 })
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
                    props.setPicking({ ...props.picking, year: props.picking.year })
                    console.log(receipt)
                }
            })
    }

    return (
        <div className='grid w-[22%] mt-20 ml-10 content-start'>
            {props.picking.day !== null ?
                <p className="text-center font-semibold text-black text-xl">
                    {monthNames[props.picking.month] + " " + (props.picking.day + 1) + ", " + props.picking.year}
                </p>
                :
                <p className='text-center text-black text-xl'>click to see detail</p>
            }
            {props.picking.day !== null &&
                <div className='grid'>
                    <p className='text-center text-black italic text-xl mt-10'>How you feel today?</p>

                    <div className='flex mt-5 place-content-between'>
                        <Amazing mood={props.form.mood} setForm={props.setForm} />
                        <Great mood={props.form.mood} setForm={props.setForm} />
                        <Average mood={props.form.mood} setForm={props.setForm} />
                        <Difficult mood={props.form.mood} setForm={props.setForm} />
                        <Tough mood={props.form.mood} setForm={props.setForm} />
                    </div>

                    <div className="flex items-center justify-center" onFocus={(e) => { props.setForm({ ...props.form, weather: e.target.value }) }}>
                        {[Array(5).keys()].map((i) => {
                            return (
                                <div>
                            <input name="rating" type="radio" id={i} className="sr-only peer" value={i}/>
                            <label htmlFor="1" className="rounded-l inline-block px-6 py-2.5 border-2 bg-gray-600 text-white font-medium text-xs leading-tight uppercase peer-hover:bg-blue-600 peer-focus:outline-none peer-checked:bg-blue-700 transition duration-150 ease-in-out">
                            i
                            </label>
                        </div>
                            )
                        }
                        )}


                    <button className='justify-self-center bg-blue-600 hover:bg-blue-800 cursor-pointer disabled:bg-blue-300 disabled:cursor-not-allowed text-white text-bold text-2xl rounded-full px-5 py-2 w-min mt-10'
                        onClick={() => addMood(props.picking.date, props.form.mood)} disabled={!props.picking.date || !props.form.mood}>OK!</button>
                    </div>
                </div>
            }
        </div>
    )
}

export default DayDetail
