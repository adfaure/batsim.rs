{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# aho-corasick-0.6.10

  crates.aho_corasick."0.6.10" = deps: { features?(features_.aho_corasick."0.6.10" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.6.10";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0bhasxfpmfmz1460chwsx59vdld05axvmk1nbp3sd48xav3d108p";
    libName = "aho_corasick";
    crateBin =
      [{  name = "aho-corasick-dot";  path = "src/main.rs"; }];
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.6.10"."memchr"}" deps)
    ]);
  };
  features_.aho_corasick."0.6.10" = deps: f: updateFeatures f (rec {
    aho_corasick."0.6.10".default = (f.aho_corasick."0.6.10".default or true);
    memchr."${deps.aho_corasick."0.6.10".memchr}".default = true;
  }) [
    (features_.memchr."${deps."aho_corasick"."0.6.10"."memchr"}" deps)
  ];


# end
# bitflags-0.7.0

  crates.bitflags."0.7.0" = deps: { features?(features_.bitflags."0.7.0" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "0.7.0";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1hr72xg5slm0z4pxs2hiy4wcyx3jva70h58b7mid8l0a4c8f7gn5";
  };
  features_.bitflags."0.7.0" = deps: f: updateFeatures f (rec {
    bitflags."0.7.0".default = (f.bitflags."0.7.0".default or true);
  }) [];


# end
# cfg-if-0.1.9

  crates.cfg_if."0.1.9" = deps: { features?(features_.cfg_if."0.1.9" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.9";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "13g9p2mc5b2b5wn716fwvilzib376ycpkgk868yxfp16jzix57p7";
  };
  features_.cfg_if."0.1.9" = deps: f: updateFeatures f (rec {
    cfg_if."0.1.9".default = (f.cfg_if."0.1.9".default or true);
  }) [];


# end
# env_logger-0.4.3

  crates.env_logger."0.4.3" = deps: { features?(features_.env_logger."0.4.3" deps {}) }: buildRustCrate {
    crateName = "env_logger";
    version = "0.4.3";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0nrx04p4xa86d5kc7aq4fwvipbqji9cmgy449h47nc9f1chafhgg";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."env_logger"."0.4.3"."log"}" deps)
    ]
      ++ (if features.env_logger."0.4.3".regex or false then [ (crates.regex."${deps."env_logger"."0.4.3".regex}" deps) ] else []));
    features = mkFeatures (features."env_logger"."0.4.3" or {});
  };
  features_.env_logger."0.4.3" = deps: f: updateFeatures f (rec {
    env_logger = fold recursiveUpdate {} [
      { "0.4.3".default = (f.env_logger."0.4.3".default or true); }
      { "0.4.3".regex =
        (f.env_logger."0.4.3".regex or false) ||
        (f.env_logger."0.4.3".default or false) ||
        (env_logger."0.4.3"."default" or false); }
    ];
    log."${deps.env_logger."0.4.3".log}".default = true;
    regex."${deps.env_logger."0.4.3".regex}".default = true;
  }) [
    (features_.log."${deps."env_logger"."0.4.3"."log"}" deps)
    (features_.regex."${deps."env_logger"."0.4.3"."regex"}" deps)
  ];


# end
# error-chain-0.10.0

  crates.error_chain."0.10.0" = deps: { features?(features_.error_chain."0.10.0" deps {}) }: buildRustCrate {
    crateName = "error-chain";
    version = "0.10.0";
    authors = [ "Brian Anderson <banderson@mozilla.com>" "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" "Yamakaky <yamakaky@yamaworld.fr>" ];
    sha256 = "1xxbzd8cjlpzsb9fsih7mdnndhzrvykj0w77yg90qc85az1xwy5z";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."error_chain"."0.10.0" or {});
  };
  features_.error_chain."0.10.0" = deps: f: updateFeatures f (rec {
    error_chain = fold recursiveUpdate {} [
      { "0.10.0".backtrace =
        (f.error_chain."0.10.0".backtrace or false) ||
        (f.error_chain."0.10.0".default or false) ||
        (error_chain."0.10.0"."default" or false); }
      { "0.10.0".default = (f.error_chain."0.10.0".default or true); }
      { "0.10.0".example_generated =
        (f.error_chain."0.10.0".example_generated or false) ||
        (f.error_chain."0.10.0".default or false) ||
        (error_chain."0.10.0"."default" or false); }
    ];
  }) [];


# end
# itoa-0.4.4

  crates.itoa."0.4.4" = deps: { features?(features_.itoa."0.4.4" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.4.4";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1fqc34xzzl2spfdawxd9awhzl0fwf1y6y4i94l8bq8rfrzd90awl";
    features = mkFeatures (features."itoa"."0.4.4" or {});
  };
  features_.itoa."0.4.4" = deps: f: updateFeatures f (rec {
    itoa = fold recursiveUpdate {} [
      { "0.4.4".default = (f.itoa."0.4.4".default or true); }
      { "0.4.4".std =
        (f.itoa."0.4.4".std or false) ||
        (f.itoa."0.4.4".default or false) ||
        (itoa."0.4.4"."default" or false); }
    ];
  }) [];


# end
# lazy_static-1.3.0

  crates.lazy_static."1.3.0" = deps: { features?(features_.lazy_static."1.3.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.3.0";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1vv47va18ydk7dx5paz88g3jy1d3lwbx6qpxkbj8gyfv770i4b1y";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.3.0" or {});
  };
  features_.lazy_static."1.3.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.3.0".default = (f.lazy_static."1.3.0".default or true); }
      { "1.3.0".spin =
        (f.lazy_static."1.3.0".spin or false) ||
        (f.lazy_static."1.3.0".spin_no_std or false) ||
        (lazy_static."1.3.0"."spin_no_std" or false); }
    ];
  }) [];


# end
# libc-0.2.55

  crates.libc."0.2.55" = deps: { features?(features_.libc."0.2.55" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.55";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1i3a7q8xpqlxfsyb421warvjwi8lvsxdcx2hzvd12qaxfpkbj3p5";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.55" or {});
  };
  features_.libc."0.2.55" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.55".align =
        (f.libc."0.2.55".align or false) ||
        (f.libc."0.2.55".rustc-dep-of-std or false) ||
        (libc."0.2.55"."rustc-dep-of-std" or false); }
      { "0.2.55".default = (f.libc."0.2.55".default or true); }
      { "0.2.55".rustc-std-workspace-core =
        (f.libc."0.2.55".rustc-std-workspace-core or false) ||
        (f.libc."0.2.55".rustc-dep-of-std or false) ||
        (libc."0.2.55"."rustc-dep-of-std" or false); }
      { "0.2.55".use_std =
        (f.libc."0.2.55".use_std or false) ||
        (f.libc."0.2.55".default or false) ||
        (libc."0.2.55"."default" or false); }
    ];
  }) [];


# end
# log-0.3.9

  crates.log."0.3.9" = deps: { features?(features_.log."0.3.9" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.3.9";
    authors = [ "The Rust Project Developers" ];
    sha256 = "19i9pwp7lhaqgzangcpw00kc3zsgcqcx84crv07xgz3v7d3kvfa2";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."log"."0.3.9"."log"}" deps)
    ]);
    features = mkFeatures (features."log"."0.3.9" or {});
  };
  features_.log."0.3.9" = deps: f: updateFeatures f (rec {
    log = fold recursiveUpdate {} [
      { "${deps.log."0.3.9".log}"."max_level_debug" =
        (f.log."${deps.log."0.3.9".log}"."max_level_debug" or false) ||
        (log."0.3.9"."max_level_debug" or false) ||
        (f."log"."0.3.9"."max_level_debug" or false); }
      { "${deps.log."0.3.9".log}"."max_level_error" =
        (f.log."${deps.log."0.3.9".log}"."max_level_error" or false) ||
        (log."0.3.9"."max_level_error" or false) ||
        (f."log"."0.3.9"."max_level_error" or false); }
      { "${deps.log."0.3.9".log}"."max_level_info" =
        (f.log."${deps.log."0.3.9".log}"."max_level_info" or false) ||
        (log."0.3.9"."max_level_info" or false) ||
        (f."log"."0.3.9"."max_level_info" or false); }
      { "${deps.log."0.3.9".log}"."max_level_off" =
        (f.log."${deps.log."0.3.9".log}"."max_level_off" or false) ||
        (log."0.3.9"."max_level_off" or false) ||
        (f."log"."0.3.9"."max_level_off" or false); }
      { "${deps.log."0.3.9".log}"."max_level_trace" =
        (f.log."${deps.log."0.3.9".log}"."max_level_trace" or false) ||
        (log."0.3.9"."max_level_trace" or false) ||
        (f."log"."0.3.9"."max_level_trace" or false); }
      { "${deps.log."0.3.9".log}"."max_level_warn" =
        (f.log."${deps.log."0.3.9".log}"."max_level_warn" or false) ||
        (log."0.3.9"."max_level_warn" or false) ||
        (f."log"."0.3.9"."max_level_warn" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_debug" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_debug" or false) ||
        (log."0.3.9"."release_max_level_debug" or false) ||
        (f."log"."0.3.9"."release_max_level_debug" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_error" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_error" or false) ||
        (log."0.3.9"."release_max_level_error" or false) ||
        (f."log"."0.3.9"."release_max_level_error" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_info" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_info" or false) ||
        (log."0.3.9"."release_max_level_info" or false) ||
        (f."log"."0.3.9"."release_max_level_info" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_off" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_off" or false) ||
        (log."0.3.9"."release_max_level_off" or false) ||
        (f."log"."0.3.9"."release_max_level_off" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_trace" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_trace" or false) ||
        (log."0.3.9"."release_max_level_trace" or false) ||
        (f."log"."0.3.9"."release_max_level_trace" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_warn" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_warn" or false) ||
        (log."0.3.9"."release_max_level_warn" or false) ||
        (f."log"."0.3.9"."release_max_level_warn" or false); }
      { "${deps.log."0.3.9".log}"."std" =
        (f.log."${deps.log."0.3.9".log}"."std" or false) ||
        (log."0.3.9"."use_std" or false) ||
        (f."log"."0.3.9"."use_std" or false); }
      { "${deps.log."0.3.9".log}".default = true; }
      { "0.3.9".default = (f.log."0.3.9".default or true); }
      { "0.3.9".use_std =
        (f.log."0.3.9".use_std or false) ||
        (f.log."0.3.9".default or false) ||
        (log."0.3.9"."default" or false); }
    ];
  }) [
    (features_.log."${deps."log"."0.3.9"."log"}" deps)
  ];


# end
# log-0.4.6

  crates.log."0.4.6" = deps: { features?(features_.log."0.4.6" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.4.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1nd8dl9mvc9vd6fks5d4gsxaz990xi6rzlb8ymllshmwi153vngr";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."log"."0.4.6"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."log"."0.4.6" or {});
  };
  features_.log."0.4.6" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.log."0.4.6".cfg_if}".default = true;
    log."0.4.6".default = (f.log."0.4.6".default or true);
  }) [
    (features_.cfg_if."${deps."log"."0.4.6"."cfg_if"}" deps)
  ];


# end
# memchr-2.2.0

  crates.memchr."2.2.0" = deps: { features?(features_.memchr."2.2.0" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.2.0";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "11vwg8iig9jyjxq3n1cq15g29ikzw5l7ar87md54k1aisjs0997p";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."memchr"."2.2.0" or {});
  };
  features_.memchr."2.2.0" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "2.2.0".default = (f.memchr."2.2.0".default or true); }
      { "2.2.0".use_std =
        (f.memchr."2.2.0".use_std or false) ||
        (f.memchr."2.2.0".default or false) ||
        (memchr."2.2.0"."default" or false); }
    ];
  }) [];


# end
# metadeps-1.1.2

  crates.metadeps."1.1.2" = deps: { features?(features_.metadeps."1.1.2" deps {}) }: buildRustCrate {
    crateName = "metadeps";
    version = "1.1.2";
    authors = [ "Josh Triplett <josh@joshtriplett.org>" ];
    sha256 = "00dpxjls9fq6fs5gr9v3hkqxmb1zwnhh8b56q3dnzghppjf3ivk3";
    dependencies = mapFeatures features ([
      (crates."error_chain"."${deps."metadeps"."1.1.2"."error_chain"}" deps)
      (crates."pkg_config"."${deps."metadeps"."1.1.2"."pkg_config"}" deps)
      (crates."toml"."${deps."metadeps"."1.1.2"."toml"}" deps)
    ]);
  };
  features_.metadeps."1.1.2" = deps: f: updateFeatures f (rec {
    error_chain."${deps.metadeps."1.1.2".error_chain}".default = (f.error_chain."${deps.metadeps."1.1.2".error_chain}".default or false);
    metadeps."1.1.2".default = (f.metadeps."1.1.2".default or true);
    pkg_config."${deps.metadeps."1.1.2".pkg_config}".default = true;
    toml."${deps.metadeps."1.1.2".toml}".default = (f.toml."${deps.metadeps."1.1.2".toml}".default or false);
  }) [
    (features_.error_chain."${deps."metadeps"."1.1.2"."error_chain"}" deps)
    (features_.pkg_config."${deps."metadeps"."1.1.2"."pkg_config"}" deps)
    (features_.toml."${deps."metadeps"."1.1.2"."toml"}" deps)
  ];


# end
# pkg-config-0.3.14

  crates.pkg_config."0.3.14" = deps: { features?(features_.pkg_config."0.3.14" deps {}) }: buildRustCrate {
    crateName = "pkg-config";
    version = "0.3.14";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0207fsarrm412j0dh87lfcas72n8mxar7q3mgflsbsrqnb140sv6";
  };
  features_.pkg_config."0.3.14" = deps: f: updateFeatures f (rec {
    pkg_config."0.3.14".default = (f.pkg_config."0.3.14".default or true);
  }) [];


# end
# proc-macro2-0.4.30

  crates.proc_macro2."0.4.30" = deps: { features?(features_.proc_macro2."0.4.30" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.4.30";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0iifv51wrm6r4r2gghw6rray3nv53zcap355bbz1nsmbhj5s09b9";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."0.4.30"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."0.4.30" or {});
  };
  features_.proc_macro2."0.4.30" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "0.4.30".default = (f.proc_macro2."0.4.30".default or true); }
      { "0.4.30".proc-macro =
        (f.proc_macro2."0.4.30".proc-macro or false) ||
        (f.proc_macro2."0.4.30".default or false) ||
        (proc_macro2."0.4.30"."default" or false); }
    ];
    unicode_xid."${deps.proc_macro2."0.4.30".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."0.4.30"."unicode_xid"}" deps)
  ];


# end
# quote-0.6.12

  crates.quote."0.6.12" = deps: { features?(features_.quote."0.6.12" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.6.12";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1ckd2d2sy0hrwrqcr47dn0n3hyh7ygpc026l8xaycccyg27mihv9";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."0.6.12"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."0.6.12" or {});
  };
  features_.quote."0.6.12" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."0.6.12".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."0.6.12".proc_macro2}"."proc-macro" or false) ||
        (quote."0.6.12"."proc-macro" or false) ||
        (f."quote"."0.6.12"."proc-macro" or false); }
      { "${deps.quote."0.6.12".proc_macro2}".default = (f.proc_macro2."${deps.quote."0.6.12".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "0.6.12".default = (f.quote."0.6.12".default or true); }
      { "0.6.12".proc-macro =
        (f.quote."0.6.12".proc-macro or false) ||
        (f.quote."0.6.12".default or false) ||
        (quote."0.6.12"."default" or false); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."0.6.12"."proc_macro2"}" deps)
  ];


# end
# regex-0.2.11

  crates.regex."0.2.11" = deps: { features?(features_.regex."0.2.11" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "0.2.11";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0r50cymxdqp0fv1dxd22mjr6y32q450nwacd279p9s7lh0cafijj";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."0.2.11"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."0.2.11"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."0.2.11"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."0.2.11"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."0.2.11"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."0.2.11" or {});
  };
  features_.regex."0.2.11" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."0.2.11".aho_corasick}".default = true;
    memchr."${deps.regex."0.2.11".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "0.2.11".default = (f.regex."0.2.11".default or true); }
      { "0.2.11".pattern =
        (f.regex."0.2.11".pattern or false) ||
        (f.regex."0.2.11".unstable or false) ||
        (regex."0.2.11"."unstable" or false); }
    ];
    regex_syntax."${deps.regex."0.2.11".regex_syntax}".default = true;
    thread_local."${deps.regex."0.2.11".thread_local}".default = true;
    utf8_ranges."${deps.regex."0.2.11".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."0.2.11"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."0.2.11"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."0.2.11"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."0.2.11"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."0.2.11"."utf8_ranges"}" deps)
  ];


# end
# regex-syntax-0.5.6

  crates.regex_syntax."0.5.6" = deps: { features?(features_.regex_syntax."0.5.6" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.5.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "10vf3r34bgjnbrnqd5aszn35bjvm8insw498l1vjy8zx5yms3427";
    dependencies = mapFeatures features ([
      (crates."ucd_util"."${deps."regex_syntax"."0.5.6"."ucd_util"}" deps)
    ]);
  };
  features_.regex_syntax."0.5.6" = deps: f: updateFeatures f (rec {
    regex_syntax."0.5.6".default = (f.regex_syntax."0.5.6".default or true);
    ucd_util."${deps.regex_syntax."0.5.6".ucd_util}".default = true;
  }) [
    (features_.ucd_util."${deps."regex_syntax"."0.5.6"."ucd_util"}" deps)
  ];


# end
# ryu-0.2.8

  crates.ryu."0.2.8" = deps: { features?(features_.ryu."0.2.8" deps {}) }: buildRustCrate {
    crateName = "ryu";
    version = "0.2.8";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1qd0ni13w19a97y51vm31biyh2pvz8j9gi78rn5in912mi04xcnk";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."ryu"."0.2.8" or {});
  };
  features_.ryu."0.2.8" = deps: f: updateFeatures f (rec {
    ryu."0.2.8".default = (f.ryu."0.2.8".default or true);
  }) [];


# end
# serde-1.0.91

  crates.serde."1.0.91" = deps: { features?(features_.serde."1.0.91" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.91";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0pv2awcqq2y99hw15nsrkghzlcar8i5wg77w636zg9d10n6db5gf";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.91" or {});
  };
  features_.serde."1.0.91" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.91".default = (f.serde."1.0.91".default or true); }
      { "1.0.91".serde_derive =
        (f.serde."1.0.91".serde_derive or false) ||
        (f.serde."1.0.91".derive or false) ||
        (serde."1.0.91"."derive" or false); }
      { "1.0.91".std =
        (f.serde."1.0.91".std or false) ||
        (f.serde."1.0.91".default or false) ||
        (serde."1.0.91"."default" or false); }
      { "1.0.91".unstable =
        (f.serde."1.0.91".unstable or false) ||
        (f.serde."1.0.91".alloc or false) ||
        (serde."1.0.91"."alloc" or false); }
    ];
  }) [];


# end
# serde_derive-1.0.91

  crates.serde_derive."1.0.91" = deps: { features?(features_.serde_derive."1.0.91" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.91";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "112w47k0b51ixd5cfn265sghs3hddh2h8vr175s23dgacnc8nxqb";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.91"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.91"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.91"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.91" or {});
  };
  features_.serde_derive."1.0.91" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.91".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.91".quote}".default = true;
    serde_derive."1.0.91".default = (f.serde_derive."1.0.91".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.91".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.91".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.91"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.91"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.91"."syn"}" deps)
  ];


# end
# serde_json-1.0.39

  crates.serde_json."1.0.39" = deps: { features?(features_.serde_json."1.0.39" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.39";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "07ydv06hn8x0yl0rc94l2wl9r2xz1fqd97n1s6j3bgdc6gw406a8";
    dependencies = mapFeatures features ([
      (crates."itoa"."${deps."serde_json"."1.0.39"."itoa"}" deps)
      (crates."ryu"."${deps."serde_json"."1.0.39"."ryu"}" deps)
      (crates."serde"."${deps."serde_json"."1.0.39"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."1.0.39" or {});
  };
  features_.serde_json."1.0.39" = deps: f: updateFeatures f (rec {
    itoa."${deps.serde_json."1.0.39".itoa}".default = true;
    ryu."${deps.serde_json."1.0.39".ryu}".default = true;
    serde."${deps.serde_json."1.0.39".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "1.0.39".default = (f.serde_json."1.0.39".default or true); }
      { "1.0.39".indexmap =
        (f.serde_json."1.0.39".indexmap or false) ||
        (f.serde_json."1.0.39".preserve_order or false) ||
        (serde_json."1.0.39"."preserve_order" or false); }
    ];
  }) [
    (features_.itoa."${deps."serde_json"."1.0.39"."itoa"}" deps)
    (features_.ryu."${deps."serde_json"."1.0.39"."ryu"}" deps)
    (features_.serde."${deps."serde_json"."1.0.39"."serde"}" deps)
  ];


# end
# syn-0.15.34

  crates.syn."0.15.34" = deps: { features?(features_.syn."0.15.34" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.15.34";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "15vmpadp8qyrri6p1mp2z59dbapwds1r2z51v8nzpf3b9c6xvzpf";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."0.15.34"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."0.15.34"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."0.15.34".quote or false then [ (crates.quote."${deps."syn"."0.15.34".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."0.15.34" or {});
  };
  features_.syn."0.15.34" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."0.15.34".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."0.15.34".proc_macro2}"."proc-macro" or false) ||
        (syn."0.15.34"."proc-macro" or false) ||
        (f."syn"."0.15.34"."proc-macro" or false); }
      { "${deps.syn."0.15.34".proc_macro2}".default = (f.proc_macro2."${deps.syn."0.15.34".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."0.15.34".quote}"."proc-macro" =
        (f.quote."${deps.syn."0.15.34".quote}"."proc-macro" or false) ||
        (syn."0.15.34"."proc-macro" or false) ||
        (f."syn"."0.15.34"."proc-macro" or false); }
      { "${deps.syn."0.15.34".quote}".default = (f.quote."${deps.syn."0.15.34".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "0.15.34".clone-impls =
        (f.syn."0.15.34".clone-impls or false) ||
        (f.syn."0.15.34".default or false) ||
        (syn."0.15.34"."default" or false); }
      { "0.15.34".default = (f.syn."0.15.34".default or true); }
      { "0.15.34".derive =
        (f.syn."0.15.34".derive or false) ||
        (f.syn."0.15.34".default or false) ||
        (syn."0.15.34"."default" or false); }
      { "0.15.34".parsing =
        (f.syn."0.15.34".parsing or false) ||
        (f.syn."0.15.34".default or false) ||
        (syn."0.15.34"."default" or false); }
      { "0.15.34".printing =
        (f.syn."0.15.34".printing or false) ||
        (f.syn."0.15.34".default or false) ||
        (syn."0.15.34"."default" or false); }
      { "0.15.34".proc-macro =
        (f.syn."0.15.34".proc-macro or false) ||
        (f.syn."0.15.34".default or false) ||
        (syn."0.15.34"."default" or false); }
      { "0.15.34".quote =
        (f.syn."0.15.34".quote or false) ||
        (f.syn."0.15.34".printing or false) ||
        (syn."0.15.34"."printing" or false); }
    ];
    unicode_xid."${deps.syn."0.15.34".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."0.15.34"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."0.15.34"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."0.15.34"."unicode_xid"}" deps)
  ];


# end
# thread_local-0.3.6

  crates.thread_local."0.3.6" = deps: { features?(features_.thread_local."0.3.6" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.3.6";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "02rksdwjmz2pw9bmgbb4c0bgkbq5z6nvg510sq1s6y2j1gam0c7i";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."thread_local"."0.3.6"."lazy_static"}" deps)
    ]);
  };
  features_.thread_local."0.3.6" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.thread_local."0.3.6".lazy_static}".default = true;
    thread_local."0.3.6".default = (f.thread_local."0.3.6".default or true);
  }) [
    (features_.lazy_static."${deps."thread_local"."0.3.6"."lazy_static"}" deps)
  ];


# end
# toml-0.2.1

  crates.toml."0.2.1" = deps: { features?(features_.toml."0.2.1" deps {}) }: buildRustCrate {
    crateName = "toml";
    version = "0.2.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0p4rkaqhmk4fp6iqpxfgp3p98hxhbs2wmla3fq531n875h922yqs";
    dependencies = mapFeatures features ([
]);
  };
  features_.toml."0.2.1" = deps: f: updateFeatures f (rec {
    toml = fold recursiveUpdate {} [
      { "0.2.1".default = (f.toml."0.2.1".default or true); }
      { "0.2.1".rustc-serialize =
        (f.toml."0.2.1".rustc-serialize or false) ||
        (f.toml."0.2.1".default or false) ||
        (toml."0.2.1"."default" or false); }
    ];
  }) [];


# end
# ucd-util-0.1.3

  crates.ucd_util."0.1.3" = deps: { features?(features_.ucd_util."0.1.3" deps {}) }: buildRustCrate {
    crateName = "ucd-util";
    version = "0.1.3";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1n1qi3jywq5syq90z9qd8qzbn58pcjgv1sx4sdmipm4jf9zanz15";
  };
  features_.ucd_util."0.1.3" = deps: f: updateFeatures f (rec {
    ucd_util."0.1.3".default = (f.ucd_util."0.1.3".default or true);
  }) [];


# end
# unicode-xid-0.1.0

  crates.unicode_xid."0.1.0" = deps: { features?(features_.unicode_xid."0.1.0" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.1.0";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "05wdmwlfzxhq3nhsxn6wx4q8dhxzzfb9szsz6wiw092m1rjj01zj";
    features = mkFeatures (features."unicode_xid"."0.1.0" or {});
  };
  features_.unicode_xid."0.1.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.1.0".default = (f.unicode_xid."0.1.0".default or true);
  }) [];


# end
# utf8-ranges-1.0.2

  crates.utf8_ranges."1.0.2" = deps: { features?(features_.utf8_ranges."1.0.2" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "1.0.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1my02laqsgnd8ib4dvjgd4rilprqjad6pb9jj9vi67csi5qs2281";
  };
  features_.utf8_ranges."1.0.2" = deps: f: updateFeatures f (rec {
    utf8_ranges."1.0.2".default = (f.utf8_ranges."1.0.2".default or true);
  }) [];


# end
# zmq-0.9.0

  crates.zmq."0.9.0" = deps: { features?(features_.zmq."0.9.0" deps {}) }: buildRustCrate {
    crateName = "zmq";
    version = "0.9.0";
    authors = [ "a.rottmann@gmx.at" "erick.tryzelaar@gmail.com" ];
    sha256 = "1vchbzcm3jh1igpwfhqfdkylmrwyr8a47ypbg5qfwgvq7ans5z8d";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."zmq"."0.9.0"."bitflags"}" deps)
      (crates."libc"."${deps."zmq"."0.9.0"."libc"}" deps)
      (crates."log"."${deps."zmq"."0.9.0"."log"}" deps)
      (crates."zmq_sys"."${deps."zmq"."0.9.0"."zmq_sys"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."zmq_sys"."${deps."zmq"."0.9.0"."zmq_sys"}" deps)
    ]);
    features = mkFeatures (features."zmq"."0.9.0" or {});
  };
  features_.zmq."0.9.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.zmq."0.9.0".bitflags}".default = true;
    libc."${deps.zmq."0.9.0".libc}".default = true;
    log."${deps.zmq."0.9.0".log}".default = true;
    zmq = fold recursiveUpdate {} [
      { "0.9.0".compiletest_rs =
        (f.zmq."0.9.0".compiletest_rs or false) ||
        (f.zmq."0.9.0".unstable-testing or false) ||
        (zmq."0.9.0"."unstable-testing" or false); }
      { "0.9.0".default = (f.zmq."0.9.0".default or true); }
      { "0.9.0".unstable =
        (f.zmq."0.9.0".unstable or false) ||
        (f.zmq."0.9.0".unstable-testing or false) ||
        (zmq."0.9.0"."unstable-testing" or false); }
      { "0.9.0".zmq_has =
        (f.zmq."0.9.0".zmq_has or false) ||
        (f.zmq."0.9.0".default or false) ||
        (zmq."0.9.0"."default" or false); }
    ];
    zmq_sys."${deps.zmq."0.9.0".zmq_sys}".default = true;
  }) [
    (features_.bitflags."${deps."zmq"."0.9.0"."bitflags"}" deps)
    (features_.libc."${deps."zmq"."0.9.0"."libc"}" deps)
    (features_.log."${deps."zmq"."0.9.0"."log"}" deps)
    (features_.zmq_sys."${deps."zmq"."0.9.0"."zmq_sys"}" deps)
    (features_.zmq_sys."${deps."zmq"."0.9.0"."zmq_sys"}" deps)
  ];


# end
# zmq-sys-0.9.0

  crates.zmq_sys."0.9.0" = deps: { features?(features_.zmq_sys."0.9.0" deps {}) }: buildRustCrate {
    crateName = "zmq-sys";
    version = "0.9.0";
    authors = [ "a.rottmann@gmx.at" "erick.tryzelaar@gmail.com" ];
    sha256 = "173s9jxkz3i43x0w9c8n7ya0sjmjfd3sjxlqzwjs6mlk4g043mv7";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."zmq_sys"."0.9.0"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."metadeps"."${deps."zmq_sys"."0.9.0"."metadeps"}" deps)
    ]);
  };
  features_.zmq_sys."0.9.0" = deps: f: updateFeatures f (rec {
    libc."${deps.zmq_sys."0.9.0".libc}".default = true;
    metadeps."${deps.zmq_sys."0.9.0".metadeps}".default = true;
    zmq_sys."0.9.0".default = (f.zmq_sys."0.9.0".default or true);
  }) [
    (features_.libc."${deps."zmq_sys"."0.9.0"."libc"}" deps)
    (features_.metadeps."${deps."zmq_sys"."0.9.0"."metadeps"}" deps)
  ];


# end
}
