/*
Run command: `npm run start`

I absolutely despise typescript for forcing me to add package.json and package-lock.json
For a stupid one file aoc problem. Thank god I don't have to touch it any more
 */
import * as fs from "fs";

const EXAMPLE_FILE = fs
    .readFileSync("example.txt")
    .toString()
    .split("\n")
    .filter((s) => s.length);
const INPUT_1 = fs
    .readFileSync("input.txt")
    .toString()
    .split("\n")
    .filter((s) => s.length);

const mod = (n: number, m: number) => {
    return ((n % m) + m) % m;
};

const moveWithClick = (dial: number, off: number) => {
    const res = dial + off;
    let click = 0;
    if (res >= 100) click = Math.floor(res / 100);
    if (res <= 0) click = Math.floor(-res / 100) + (dial !== 0 ? 1 : 0);
    return { res: mod(res, 100), click };
};

const solve1 = (moves: string[]) => {
    let dial = 50;
    let sol = 0;
    moves.forEach((m) => {
        const off = parseInt(m.slice(1));
        let sign = -1;
        if (m[0] === "L") sign = -1;
        if (m[0] === "R") sign = 1;
        dial = dial + sign * off;
        dial = mod(dial, 100);
        if (dial === 0) sol += 1;
    });
    return sol;
};

const solve2 = (moves: string[]) => {
    let dial = 50;
    let sol = 0;
    moves.forEach((m) => {
        const off = parseInt(m.slice(1));
        let sign = -1;
        if (m[0] === "L") sign = -1;
        if (m[0] === "R") sign = 1;
        const { res, click } = moveWithClick(dial, sign * off);
        dial = res;
        sol += click;
    });
    return sol;
};

console.log(solve1(EXAMPLE_FILE));
console.log(solve2(EXAMPLE_FILE));
console.log(solve1(INPUT_1));
console.log(solve2(INPUT_1));
