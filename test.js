const solution = (a, b) => {
  // thought on numbers that pass the test
  // num is positive
  // consective numbers are close to sqrt
  let counter = 0;
  for (let i = a; i <= b; i++) {
    if (i % 2 === 0) {
      let sqrt = Math.sqrt(i);
      let floor = Math.floor(sqrt);
      let ceil = Math.ceil(sqrt);
      if (floor * ceil === i && floor !== ceil) {
        counter++;
        console.log(i);
      }
    } else {
      continue;
    }
  }
  return counter;
};

// solution(6, 20);

// console.log(solution(21, 29));
