program prize.aleo {
	const GOLD: u8 = 0u8;
	const SILVER: u8 = 1u8;
	const BRONZE: u8 = 2u8;

	mapping gold_prizes: address => u64;
	mapping silver_prizes: address => u64;
	mapping bronze_prizes: address => u64;
    mapping current_prize: address => u8;
	
    // Transition function to randomize the current prize available.
	async transition randomize_prize() -> Future {
        // Randomize the prize that the caller can collect.
        return finalize_randomize_prize(self.signer);
    }

    // Finalize the prize randomization on-chain.
    async function finalize_randomize_prize(caller: address) {
        // Randomizes the prize the caller can receive between gold, silver and bronze.
        Mapping::set(current_prize, caller, ChaCha::rand_u8() % 3u8);
    }

    // Collect the current receivable prize.
	async transition collect_prize() -> Future {
        return finalize_collect_prize(self.signer);
    }

    // Finalize the prize collection on-chain.
    async function finalize_collect_prize(caller: address) {
        // Get the current prize values assigned to the caller.
        let cur_gold: u64 = Mapping::get_or_use(gold_prizes, caller, 0u64);
        let cur_silver: u64 = Mapping::get_or_use(silver_prizes, caller, 0u64);
        let cur_bronze: u64 = Mapping::get_or_use(bronze_prizes, caller, 0u64);
        // See what prize the caller can collect. This defaults to bronze.
        let cur_prize: u8 = Mapping::get_or_use(current_prize, caller, BRONZE);
        // Give the prize to the caller.
        if cur_prize == GOLD {
            Mapping::set(gold_prizes, caller, cur_gold + 1u64);
        } else if cur_prize == SILVER {
            Mapping::set(silver_prizes, caller, cur_silver + 1u64); 
        } else {
            Mapping::set(bronze_prizes, caller, cur_bronze + 1u64); 
        }
    }
}
