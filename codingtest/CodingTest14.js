/*
web3.js 혹은 ethers.js를 사용하시면 됩니다.
NFT 1개를 선택하여 특정 지갑주소가 거래했는지 살펴보는 함수를 구현하세요.
맨 처음부터 구현하면 됩니다. 개인키와 api는 비워놓으시면 됩니다.
*/

var {ethers} = require('ethers')
var provider = new ethers.InfuraProvider()

// 서명
var privateKey = PRIVATE_KEY
var signer = new ethers.Wallet(privateKey, provider)

// PudgyPenguins (PPG) NFT 선택
var c_address = '0xBd3531dA5CF5857e7CfAA92426877b022e612cf8'
var miniABI = [{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Transfer","type":"event"}]

var contract = new ethers.Contract(c_address, miniABI, signer)

// NFT 아이디 선택
var tokenId = 5508;

// 5508 토큰에 거래 내역이 있는 지갑 주소
var existAddr = '0x2AC69CdB08b2c6622f75CD68309250fb8e2B766e'

// Transfer(from, to, tokenID)
var transferEventFilter1 = contract.filters.Transfer(existAddr, null, tokenId); // 해당 주소가 from
var transferEventFilter2 = contract.filters.Transfer(null, existAddr, tokenId); // 해당 주소가 to

// Transfer 이벤트 로그 가져오기
var logs1 = await contract.queryFilter(transferEventFilter1);
var logs2 = await contract.queryFilter(transferEventFilter2);

console.log('[', tokenId, '] ', existAddr, ' => ', logs1.length + logs2.length != 0)


// 5508 토큰에 거래 내역이 없는 지갑 주소
var nonExistAddr = '0x368116D67D389eF8ACC79C9b8476b8a4d000ac8D'

// Transfer(from, to, tokenID)
var transferEventFilter1 = contract.filters.Transfer(nonExistAddr, null, tokenId); // 해당 주소가 from
var transferEventFilter2 = contract.filters.Transfer(null, nonExistAddr, tokenId); // 해당 주소가 to

// Transfer 이벤트 로그 가져오기
var logs1 = await contract.queryFilter(transferEventFilter1);
var logs2 = await contract.queryFilter(transferEventFilter2);

console.log('[', tokenId, '] ', nonExistAddr, ' => ', logs1.length + logs2.length != 0)
