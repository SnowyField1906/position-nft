import { ethers } from "ethers"
import { contractABI, contractAddress } from '../utils/index'

export const turnOnWeb3 = () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
    window.ethereum.request({ method: 'eth_requestAccounts' })
    return new Promise(async (resolve, reject) => {
        if (window.ethereum) {
            try {
                const { chainId } = await provider.getNetwork()
                chainId === 5 ?? alert('Please connect to the Goerli Test Network')
            } catch (error) {
                reject(error)
                return false
            } finally {
                resolve(provider)
            }
        } else {
            reject('Please check your MetaMask!')
        }
    })
}

export const authencation = () => {
    return new Promise(async (resolve) => {
        await turnOnWeb3().then((provider) => {
            const signer = provider.getSigner()
            const contractInstance = new ethers.Contract(contractAddress, contractABI, signer)
            resolve({ signer, contractInstance })
        })
    })
}

export const transactionStatus = (tx) => {
    return new Promise(async (resolve, reject) => {
        try {
            const receipt = await tx.wait()
            resolve(receipt)
        } catch (error) {
            reject(error)
        }
    })
}