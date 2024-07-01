import prize.aleo;
program collector.aleo {
    const GOLD: u8 = 0u8;
	const SILVER: u8 = 1u8;
	const BRONZE: u8 = 2u8;
    
    // Increase odds of winning prizes by randomizing multiple times.
    async transition win_prize() -> Future {
        // Call the external transitions in an arbitrary order offline. 
        let f0: Future = prize.aleo/collect_prize();
        // Can add more external randomizatio calls to increase the probability of winning gold.
        let (f1, f2): (Future, Future) = (prize.aleo/randomize_prize(), prize.aleo/randomize_prize());
        return finalize_win_prize(self.signer, f0, f1, f2);
    }

    // Here we strategically alternate between randomizing the prize, and checking to see if the prize is gold.
    // Note that a transaction can only be finalized if every future is awaited exactly once.
    async function finalize_win_prize(caller: address, f_collect: Future, f_randomize_1: Future, f_randomize_2: Future) {
        // Get our current gold balance.
        let current_gold_balance: u64 = Mapping::get_or_use(prize.aleo/gold_prizes, caller, 0u64);

        f_randomize_1.await();
        // Collect prize if it is gold.
        if Mapping::get_or_use(prize.aleo/current_prize, caller, BRONZE) == GOLD {
            f_collect.await();
        }
        // Otherwise try again.
        f_randomize_2.await();
        // Note that we do not want to try collecting again if we have already won gold, as that will cause the transaction to abort.
        if Mapping::get_or_use(prize.aleo/current_prize, caller, BRONZE) == GOLD && current_gold_balance == Mapping::get_or_use(prize.aleo/gold_prizes, caller, 0u64) {
            f_collect.await();
        }
        // In the case we got unlucky, we will not have awaited the collection future, meaning we must await it now and settle for a lower prize.
        if current_gold_balance == Mapping::get_or_use(prize.aleo/gold_prizes, caller, 0u64) {
            f_collect.await();
        }
    }
}
