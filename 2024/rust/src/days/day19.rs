use std::collections::HashSet;
use std::collections::HashMap;
use rayon::prelude::*;

#[derive(Debug, Default)]
struct Trie {
    leaves: HashMap<char, Trie>,
    end: bool,
}

impl Trie {
    fn insert(&mut self, pattern: &str) {
        let mut node = self;
        for c in pattern.chars() {
            node = node.leaves.entry(c).or_default();
        };
        node.end = true;
    }

    // pretty print 
    fn pretty_print(&self, level: usize) {
        for (c, node) in &self.leaves {
            println!("{:indent$}{} ", "", c, indent = level);
            node.pretty_print(level + 1);
        }
    }
}

pub fn ways_trie(target: &str, patterns: &Trie) -> u64 {
    let n = target.len();
    let mut dp = vec![0; n + 1];
    dp[0] = 1;

    for k in 1..=n {
        let mut node = patterns;

        for j in (0..k).rev() {
            if let Some(next)
             = node.leaves.get(&target[j..j+1].chars().next().unwrap()) {
                if next.end {
                    dp[k] += dp[j];
                }
                node = next;
            } else {
                break;
            }
        }
    }

    return dp[n];
}

pub fn ways(target: &str, patterns: &HashSet<&str>) -> u64 {
    let n = target.len();
    let mut dp = vec![0; n + 1];
    dp[0] = 1;

    (1..=n).for_each(|k| {
        for plen in 1..=k {
            if patterns.contains(&target[k - plen..k]) {
                dp[k] += dp[k - plen];
            }
        }        
    });

    return dp[n];
}

pub fn ways_2(target: &str, patterns: &Vec<&str>) -> u64 {
    let n = target.len();
    let mut dp = vec![0; n + 1];
    dp[0] = 1;

    (1..=n).for_each(|k| {
        patterns.iter().for_each(|pattern| {
            if k >= pattern.len() && target[k - pattern.len()..k] == **pattern {
                dp[k] += dp[k - pattern.len()];
            }
        });
    });
    
    return dp[n];
}

pub fn p1() -> u64 {
    let t0 = std::time::Instant::now();
    let input = std::fs::read_to_string("../data/19.txt").unwrap();
    let input = input.split("\n\n").collect::<Vec<&str>>();
    // input is patterns \n\n towels 
    let mut patterns = input[0].split(", ").collect::<Vec<&str>>();
    let towel = input[1].lines().collect::<Vec<&str>>();

    let patterns_set: HashSet<&str> = patterns.iter().cloned().collect();
    
    let mut patterns_trie = Trie::default();
    for p in &patterns {
        patterns_trie.insert(p);
    }
    
    //println!("{:?}", patterns_trie);
    /* 
    let mut count = 0;
    let mut total_ways = 0;

         
    for t in &towel {
        let ways = ways(t, &patterns_set);
        if ways > 0 {
            count += 1;
        }
        total_ways += ways;
    }
    */    
 
    let (mut count, mut total_ways) = towel.par_iter().fold(|| (0, 0), |acc, t| {
        let ways = ways_trie(t, &patterns_trie);
        if ways > 0 {
            (acc.0 + 1, acc.1 + ways)
        } else {
            (acc.0, acc.1)
        }
    }).reduce(|| (0, 0), |a, b| (a.0 + b.0, a.1 + b.1));

    let elapsed = t0.elapsed();
    println!("elapsed: {:?}", elapsed);
    println!("{:?}", count);
    println!("{:?}", total_ways);
    return 0
}