const {expect} = require("chai");

describe("CPMM Contract Test", function () {
    it("CPMM Contract Test 01", async function () {
        // 지갑주소 생성
        const [owner, user1, user2, user3, user4] = await ethers.getSigners();
        
        // Contract 생성
        const conA = await ethers.deployContract("A");
        const conB = await ethers.deployContract("B");
        // 초기 상태 : A: 100,000, B: 300,000, LP: 1,000,000
        const conCPMM = await ethers.deployContract("CPMM", [conA.target, conB.target, 100000, 300000, 1000000]);
        
        // 유저 1 토큰 발행. A: 30,000, B: 10,000 및 appove
        await conA.connect(user1).mint(30000);
        await conB.connect(user1).mint(90000);
        await conA.connect(user1).approve(conCPMM.target, 30000);
        await conB.connect(user1).approve(conCPMM.target, 90000);

        // 유저 2 토큰 발행. A: 20,000, B: 60,000 및 appove
        await conA.connect(user2).mint(20000);
        await conB.connect(user2).mint(60000);
        await conA.connect(user2).approve(conCPMM.target, 20000);
        await conB.connect(user2).approve(conCPMM.target, 60000);

        // 유저 3 토큰 발행. A: 25000 및 appove
        await conA.connect(user3).mint(25000);
        await conA.connect(user3).approve(conCPMM.target, 25000);

        // 유저 4 토큰 발행. B: 50000 및 appove
        await conB.connect(user4).mint(50000);
        await conB.connect(user4).approve(conCPMM.target, 50000);

        // CPMM의 초기 공급량, allow 잔고 확인
        expect(await conA.balanceOf(conCPMM.target)).to.equal(100000);
        expect(await conB.balanceOf(conCPMM.target)).to.equal(300000);
        expect(await conCPMM.totalSupply()).to.equal(1000000);
        expect(await conA.allowance(user1, conCPMM.target)).to.equal(30000);
        expect(await conA.allowance(user2, conCPMM.target)).to.equal(20000);
        expect(await conA.allowance(user3, conCPMM.target)).to.equal(25000);
        expect(await conB.allowance(user1, conCPMM.target)).to.equal(90000);
        expect(await conB.allowance(user2, conCPMM.target)).to.equal(60000);
        expect(await conB.allowance(user4, conCPMM.target)).to.equal(50000);

        // 시나리오 1. 유저 1가 A 토큰 30,000개를 유동성 제공. B 토큰과 LP 토큰개수
        {
            var originB = await conB.balanceOf(conCPMM.target); // 기존 토큰 B
            await conCPMM.connect(user1).addLiquidity(conA.target, 30000); // 유동성 제공
            var newB = await conB.balanceOf(conCPMM.target); // 늘어난 토큰 B
            expect(newB - originB).to.equal(90000); // 유저 1이 낸 B 토큰
            expect(await conCPMM.balanceOf(user1)).to.equal(300000); // 유저 1이 받은 LP 토큰
        }
        
        // 시나리오 2. 유저 2가 B 토큰 60,000개를 유동성 제공. A토큰과 LP 토큰 개수
        {
            var originA = await conA.balanceOf(conCPMM.target); // 기존 토큰 A
            await conCPMM.connect(user2).addLiquidity(conB.target, 60000); // 유동성 제공
            var newA = await conA.balanceOf(conCPMM.target); // 늘어난 토큰 A
            expect(newA - originA).to.equal(20000); // 유저 2가 낸 A 토큰
            expect(await conCPMM.balanceOf(user2)).to.equal(200000); // 유저 2가 받은 LP 토큰
        }

        // 시나리오 3. 유저 3이 A 토큰 25,000개 매도. 유저 3이 받을 B 토큰의 개수와 변화할 K 값 
        {
            await conCPMM.connect(user3).swap(conA.target, 25000); // A2B 스왑
            expect(await conB.balanceOf(user3)).to.equal(64221); // 유저 3이 받는 B토큰
            expect(await conCPMM.getK()).to.equal(67511325000); // 변화한 K
        }

        // 시나리오 4. 유저 4가 B 토큰 50,000개 매도. 유저 4가 받을 A 토큰의 개수와 변화할 K 값 
        {
            await conCPMM.connect(user4).swap(conB.target, 50000); // B2A 스왑
            expect(await conA.balanceOf(user4)).to.equal(20058); // 유저 4가 받는 A토큰
            expect(await conCPMM.getK()).to.equal(67520469818); // 변화한 K
        }

        // 시나리오 5. 유저 1이 유동성 회수 (-300,000 LP).
        // 유저 1이 받을 A 토큰과 B 토큰의 개수와 변화할 K 값 
        {
            await conCPMM.connect(user1).withLiquidity(300000); // 유동성 회수
            expect(await conA.balanceOf(user1)).to.equal(30988); // 유저 1이 받는 A토큰
            expect(await conB.balanceOf(user1)).to.equal(87155); // 유저 1이 받는 B토큰
            expect(await conCPMM.getK()).to.equal(43213339296); // 변화한 K
        }

        // 시나리오 6. 유저 2가 유동성 회수 (-1,800,000 LP Token)
        // 유저 2가 받을 A 토큰과 B 토큰의 개수와 변화할 K 값 
        {
            await conCPMM.connect(user2).withLiquidity(200000); // 유동성 회수
            expect(await conA.balanceOf(user2)).to.equal(20659); // 유저 2가 받는 A토큰
            expect(await conB.balanceOf(user2)).to.equal(58104); // 유저 2가 받는 B토큰
            expect(await conCPMM.getK()).to.equal(30009263400); // 변화한 K
        }
    });
    
    it("CPMM Contract Test 02", async function () {
        // 지갑주소 생성
        const [owner, user1, user2, user3] = await ethers.getSigners();
        
        // Contract 생성
        const conA = await ethers.deployContract("A");
        const conB = await ethers.deployContract("B");
        // 초기 상태 : A: 500,000, B: 2,500,000, LP: 2,500,000
        const conCPMM = await ethers.deployContract("CPMM", [conA.target, conB.target, 500000, 2500000, 2500000]);
        
        // 유저 1 토큰 발행. A: 50,000 및 appove
        await conA.connect(user1).mint(50000);
        await conB.connect(user1).mint(250000);
        await conA.connect(user1).approve(conCPMM.target, 50000);
        await conB.connect(user1).approve(conCPMM.target, 250000);

        // 유저 2 토큰 발행. B: 100,000 및 appove
        await conA.connect(user2).mint(20000);
        await conB.connect(user2).mint(100000);
        await conA.connect(user2).approve(conCPMM.target, 20000);
        await conB.connect(user2).approve(conCPMM.target, 100000);

        // 유저 3 토큰 발행. A: 1,000,000 및 appove
        await conA.connect(user3).mint(1000000);
        await conA.connect(user3).approve(conCPMM.target, 1000000);

        // CPMM의 초기 공급량, allow 잔고 확인
        expect(await conA.balanceOf(conCPMM.target)).to.equal(500000);
        expect(await conB.balanceOf(conCPMM.target)).to.equal(2500000);
        expect(await conCPMM.totalSupply()).to.equal(2500000);
        expect(await conA.allowance(user1, conCPMM.target)).to.equal(50000);
        expect(await conB.allowance(user1, conCPMM.target)).to.equal(250000);
        expect(await conA.allowance(user2, conCPMM.target)).to.equal(20000);
        expect(await conB.allowance(user2, conCPMM.target)).to.equal(100000);
        expect(await conA.allowance(user3, conCPMM.target)).to.equal(1000000);

        // 시나리오 1. 유저 1가 A 토큰 50,000개를 유동성 제공
        // 유저 1이 제공해야할 B토큰과 받을 LP 토큰 개수
        {
            var originB = await conB.balanceOf(conCPMM.target); // 기존 토큰 B
            await conCPMM.connect(user1).addLiquidity(conA.target, 50000); // 유동성 제공
            var newB = await conB.balanceOf(conCPMM.target); // 늘어난 토큰 B
            expect(newB - originB).to.equal(250000); // 유저 1이 낸 B 토큰
            expect(await conCPMM.balanceOf(user1)).to.equal(250000); // 유저 1이 받은 LP 토큰
        }

        // 시나리오 2. 유저 2가 B 토큰 100,000개를 유동성 제공
        // 유저 2가 제공해야할 A토큰과 받을 LP 토큰 개수
        {
            var originA = await conA.balanceOf(conCPMM.target); // 기존 토큰 A
            await conCPMM.connect(user2).addLiquidity(conB.target, 100000); // 유동성 제공
            var newA = await conA.balanceOf(conCPMM.target); // 늘어난 토큰 A
            expect(newA - originA).to.equal(20000); // 유저 2가 낸 A 토큰
            expect(await conCPMM.balanceOf(user2)).to.equal(100000); // 유저 2가 받은 LP 토큰
        }

        // 시나리오 3. 유저 3이 A 토큰 2,500개 매도
        // 유저 3이 받을 B 토큰의 개수와 변화할 K 값
        {
            await conCPMM.connect(user3).swap(conA.target, 2500); // A2B 스왑
            expect(await conB.balanceOf(user3)).to.equal(12432); // 유저 3이 받는 B토큰
            expect(await conCPMM.getK()).to.equal(1624507680000); // 변화한 K
        }

        // 시나리오 4. 유저 3이 A 토큰 2,500개 매도
        // 유저 3이 받을 B 토큰의 개수와 변화할 K 값
        {
            var originB = await conB.balanceOf(user3); // 기존 토큰 B
            await conCPMM.connect(user3).swap(conA.target, 2500); // A2B 스왑
            var newB = await conB.balanceOf(user3); // 늘어난 토큰 B
            expect(newB-originB).to.equal(12324); // 유저 3이 받는 B토큰
            expect(await conCPMM.getK()).to.equal(1624515300000); // 변화한 K
        }

        // 시나리오 5. 유저 3이 A 토큰 2,500개 매도
        // 유저 3이 받을 B 토큰의 개수와 변화할 K 값
        {
            var originB = await conB.balanceOf(user3); // 기존 토큰 B
            await conCPMM.connect(user3).swap(conA.target, 2500); // A2B 스왑
            var newB = await conB.balanceOf(user3); // 늘어난 토큰 B
            expect(newB-originB).to.equal(12218); // 유저 3이 받는 B토큰
            expect(await conCPMM.getK()).to.equal(1624522515000); // 변화한 K
        }        

        // 이벤트 리스너 설정
        conCPMM.on("Warning", (updater, A, B) => {
            console.log(`[Event] ${updater} (${A}:${B})`);
        });

        // 시나리오 6. 알람 뜰 때까지 while문 돌리기
        for(var i = 6; i < 98; i++){
            await conCPMM.connect(user3).swap(conA.target, 2500)
        }
        
        // 이벤트 리스너가 이벤트 받을 수 있도록 Sleep
        await Sleep(1000);
    });    
});

async function Sleep (ms) {
    let promise = new Promise((resolve, reject) => {
        setTimeout(() => resolve("완료!"), ms)
    });

    await promise;
}