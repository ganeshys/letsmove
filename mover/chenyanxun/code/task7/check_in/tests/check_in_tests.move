#[test_only]
module check_in::check_in_tests {
    use std::debug;
    use std::vector;
    use std::bcs;
    use std::hash::sha3_256;
    use std::ascii::{String, string};
    // uncomment this line to import the module
    // use check_in::check_in;

    const ENotImplemented: u64 = 0;
    const ESTRING: u64 = 0;

    #[test]
    fun test_check_in() {
        // pass
        let flag_str= string(b"<83yJV{nK{V");
        let github_id = string(b"chenyanxun");

        let mut bcs_flag = bcs::to_bytes(&flag_str);
        vector::append<u8>(&mut bcs_flag, *github_id.as_bytes());

        debug::print(&sha3_256(bcs_flag));
        //assert!(flag == sha3_256(bcs_flag), ESTRING);
    }
}