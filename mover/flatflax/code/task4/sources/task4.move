/// Module: task4
module task4::game {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::random::{Self, Random};
    use faucet_coin::faucet_coin::FAUCET_COIN;

    const EUserInsufficientBalance: u64 = 1000;
    const EGameInsufficientBalance: u64 = 1001;

    public struct Game has key {
        id: UID,
        balance: Balance<FAUCET_COIN>,
        game_name:vector<u8>
    }

    public struct Admin has key {
        id: UID,
    }

    fun init(ctx: &mut TxContext) {
        let game = Game {
            id: object::new(ctx),
            balance: balance::zero(),
            game_name:b"FLATFLAX GAME"

        };
        transfer::share_object(game);

        let admin = Admin{id: object::new(ctx)};
        transfer::transfer(admin, ctx.sender());
    }

    public entry fun deposit(game: &mut Game, coin: &mut Coin<FAUCET_COIN>, amount: u64, ctx: &mut TxContext) {
        assert!(coin.value() >= amount, EUserInsufficientBalance);
        let split_balance = coin::balance_mut(coin).split(amount);
        game.balance.join(split_balance);
    }

    public entry fun withdraw(game: &mut Game, _: &Admin, amount: u64, ctx: &mut TxContext) {
        assert!(game.balance.value() >= amount, EGameInsufficientBalance);
        let cash = coin::take(&mut game.balance, amount, ctx);
        transfer::public_transfer(cash, ctx.sender());
    }

    public entry fun play(game: &mut Game, rnd: &Random, guess: bool, coin: &mut Coin<FAUCET_COIN>, amount: u64, ctx: &mut TxContext) {
        assert!(game.balance.value() >= amount, EGameInsufficientBalance);
        assert!(coin.value() >= amount, EUserInsufficientBalance);

        let mut gen = random::new_generator(rnd, ctx);
        let flag = random::generate_bool(&mut gen);

        if (flag == guess) {
            // 猜对,将奖励发送到玩家账户
            let reward = coin::take(&mut game.balance, amount, ctx);
            coin.join(reward);
        }else {
            //猜错，将赌注存入奖池
            Self::deposit(game, coin, amount,ctx)
        }
    }
}


