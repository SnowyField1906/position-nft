import { useEffect, useState } from 'react'
import { turnOnWeb3 } from './provider/'

import Mint from './container/Mint'
import Pool from './components/Pool';

function App() {


	return (
		<>
			<Mint />
		</>
	)
}

export default App;