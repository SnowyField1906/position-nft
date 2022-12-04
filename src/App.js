import { useEffect, useState } from 'react'
import { turnOnWeb3 } from './provider/'

import Mint from './container/Mint'
import Gallery from './container/Gallery';

function App() {


	return (
		<>
			<Mint />
			<Gallery />
		</>
	)
}

export default App;