import prize.aleo;
program collector.aleo;




function win_prize:
    call prize.aleo/collect_prize into r0;
    call prize.aleo/randomize_prize into r1;
    call prize.aleo/randomize_prize into r2;
    async win_prize self.signer r0 r1 r2 into r3;
    output r3 as collector.aleo/win_prize.future;

finalize win_prize:
    input r0 as address.public;
    input r1 as prize.aleo/collect_prize.future;
    input r2 as prize.aleo/randomize_prize.future;
    input r3 as prize.aleo/randomize_prize.future;
    get.or_use prize.aleo/gold_prizes[r0] 0u64 into r4;
    await r2;
    get.or_use prize.aleo/current_prize[r0] 2u8 into r5;
    is.eq r5 0u8 into r6;
    branch.eq r6 false to end_then_0_0;
    await r1;
    branch.eq true true to end_otherwise_0_1;
    position end_then_0_0;
    position end_otherwise_0_1;
    await r3;
    get.or_use prize.aleo/current_prize[r0] 2u8 into r7;
    is.eq r7 0u8 into r8;
    get.or_use prize.aleo/gold_prizes[r0] 0u64 into r9;
    is.eq r4 r9 into r10;
    and r8 r10 into r11;
    branch.eq r11 false to end_then_0_2;
    await r1;
    branch.eq true true to end_otherwise_0_3;
    position end_then_0_2;
    position end_otherwise_0_3;
    get.or_use prize.aleo/gold_prizes[r0] 0u64 into r12;
    is.eq r4 r12 into r13;
    branch.eq r13 false to end_then_0_4;
    await r1;
    branch.eq true true to end_otherwise_0_5;
    position end_then_0_4;
    position end_otherwise_0_5;

