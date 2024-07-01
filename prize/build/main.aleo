program prize.aleo;



mapping gold_prizes:
	key as address.public;
	value as u64.public;


mapping silver_prizes:
	key as address.public;
	value as u64.public;


mapping bronze_prizes:
	key as address.public;
	value as u64.public;


mapping current_prize:
	key as address.public;
	value as u8.public;


function randomize_prize:
    async randomize_prize self.signer into r0;
    output r0 as prize.aleo/randomize_prize.future;

finalize randomize_prize:
    input r0 as address.public;
    rand.chacha into r1 as u8;
    rem r1 3u8 into r2;
    set r2 into current_prize[r0];




function collect_prize:
    async collect_prize self.signer into r0;
    output r0 as prize.aleo/collect_prize.future;

finalize collect_prize:
    input r0 as address.public;
    get.or_use gold_prizes[r0] 0u64 into r1;
    get.or_use silver_prizes[r0] 0u64 into r2;
    get.or_use bronze_prizes[r0] 0u64 into r3;
    get.or_use current_prize[r0] 2u8 into r4;
    is.eq r4 0u8 into r5;
    branch.eq r5 false to end_then_0_0;
    add r1 1u64 into r6;
    set r6 into gold_prizes[r0];
    branch.eq true true to end_otherwise_0_1;
    position end_then_0_0;
    is.eq r4 1u8 into r7;
    branch.eq r7 false to end_then_1_2;
    add r2 1u64 into r8;
    set r8 into silver_prizes[r0];
    branch.eq true true to end_otherwise_1_3;
    position end_then_1_2;
    add r3 1u64 into r9;
    set r9 into bronze_prizes[r0];
    position end_otherwise_1_3;
    position end_otherwise_0_1;

