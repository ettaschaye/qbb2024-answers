## Genome assembly
### Etta Schaye
### Due September 20th, 2024

### Done in Python 3.12.3

### Import packages 
import numpy
import scipy
import scipy.stats
import math

## Exercise 1

## Step 1.1
### **How many 100bp reads are needed to sequence a 1Mbp genome to 3X coverage?**
```genome_size = 1000000
desired_coverage = 3
read_length = 100
num_reads = int((genome_size * desired_coverage)/read_length)
```
30,000 100 bp reads are required 

## Step 1.2
### Produce a 1D array (genome_coverage) with 1 million positions and a zero at every position
```genome_coverage = numpy.zeros(1000000, dtype= int)```

### Simulate sequencing 3X coverage of a 1 millon bp genome
**1. Use NumPy's pseudo-random number generator function to choose an integer between 0 and 999,900 to serve as our start position**
**2. Calculate the end position that corresponds to the randomly calculated start position**
**3. Take our array with a 0 at every position and add 1 to every value between the start and end position and save that as the new value**
**Repeat this process for all 30,000 simulated reads**

  for i in range(30000):
        startpos = numpy.random.randint(0,999900)
        endpos = startpos + 100 
        genome_coverage[startpos:endpos] += 1

**4. Save the coverage for each position in the genome as a text file**
```numpy.savetxt('genome_coverage.csv', genome_coverage, fmt='%d', delimiter=',')```

**5. Look within the genome coverage array and find the position with the highest value, which has been "sequenced" the most**
```maxcoverage = numpy.max(genome_coverage)```

**6. Define 0 as the lower bound of coverages observed and the upper bound is the maximum coverage observed for any position in the array + 1**
```xs = list(range(0, maxcoverage+1))``` 

### Calculate probability functions
**1. Calculate the Poisson probability mass function**
**In a poisson distribution, the x-axis is k (the number of occurrences), λ is the expected rate of occurrences, and the y axis is the probability of k occurrences given λ**
***In our case, we want to calculate the likelihood of getting any coverage level between 0 and our max for any particular position, with an average coverage of 3X**
```poisson_results = scipy.stats.poisson.pmf(xs, 3)```

**2. Calculate the normal distribution probability density function**

```normal_estimates = scipy.stats.norm.pdf(xs, loc = 3, scale = math.sqrt(3))```

**3. Save the results as text files**

```numpy.savetxt('poisson_results.csv', poisson_results, fmt='%.8e', delimiter=',')```
```numpy.savetxt('normal_estimates.csv', normal_estimates, fmt='%.8e', delimiter=',')```

**In your simulation, how much of the genome has not been sequenced (has 0x coverage)?**
50687 positions were not sequenced 
**How well does this match Poisson expectations? How well does the normal distribution fit the data?**
The Poisson estimate would be 49787 unsequenced nucleotides and the normal distribution predicts 51272 unsequenced nucleotides, so both distributions fit the simulated data fairly well on the low end. However, the normal distribution predicts higher coverage than what was simulated. 

## Step 1.5
### Repeat the simulation with 10X coverage 
### **How many 100bp reads are needed to sequence a 1Mbp genome to 10X coverage?**
```
genome_size = 1000000
desired_coverage = 10
read_length = 100
num_reads = int((genome_size * desired_coverage)/read_length)
```

100,000 100 bp reads are required 

### Produce a 1D array (genome_coverage_10X) with 1 million positions and a zero at every position
```genome_coverage_10X = numpy.zeros(1000000, dtype= int)```

### Simulate sequencing 10X coverage of a 1 millon bp genome
**1. Use NumPy's pseudo-random number generator function to choose an integer between 0 and 999,900 to serve as our start position**
**2. Calculate the end position that corresponds to the randomly calculated start position**
**3. Take our array with a 0 at every position and add 1 to every value between the start and end position and save that as the new value**
**Repeat this process for all 100,000 simulated reads**
```
for i in range(100000):
    startpos = numpy.random.randint(0,999900)
    endpos = startpos + 100 
    genome_coverage_10X[startpos:endpos] += 1

  **4. Save the coverage for each position in the genome as a text file**
numpy.savetxt('genome_coverage_10X.csv', genome_coverage_10X, fmt='%d', delimiter=',')
```

**5. Look within the genome coverage array and find the position with the highest value, which has been "sequenced" the most**
```maxcoverage_10X = numpy.max(genome_coverage_10X)```

**6. Define 0 as the lower bound of coverages observed and the upper bound is the maximum coverage observed for any position in the array + 1**
```xs_10X = list(range(0, maxcoverage_10X+1))```

### Calculate probability functions
**1. Calculate the Poisson probability mass function**
**In a poisson distribution, the x-axis is k (the number of occurrences), λ is the expected rate of occurrences, and the y axis is the probability of k occurrences given λ**
***In our case, we want to calculate the likelihood of getting any coverage level between 0 and our max for any particular position, with an average coverage of 3X**
```poisson_results_10X = scipy.stats.poisson.pmf(xs_10X, 10)```

**2. Calculate the normal distribution probability density function**

```normal_estimates_10X = scipy.stats.norm.pdf(xs_10X, loc = 10, scale = math.sqrt(10))```

**3. Save the results as text files**

```numpy.savetxt('poisson_results_10X.csv', poisson_results, fmt='%.8e', delimiter=',')```
```numpy.savetxt('normal_estimates_10X.csv', normal_estimates, fmt='%.8e', delimiter=',')```

**In your simulation, how much of the genome has not been sequenced (has 0x coverage)?**
64 nucleotides have not been sequenced 
**How well does this match Poisson expectations? How well does the normal distribution fit the data?**
The Poisson estimate would be 45.4 unsequenced nucleotides and the normal distribution predicts 845 unsequenced nucleotides, so the Poisson estimate is fairly good and the normal distribution is a poorer predictor. The normal distribution overestimates coverage in general. 
## Step 1.6

### Repeat the simulation with 30X coverage 
### **How many 100bp reads are needed to sequence a 1Mbp genome to 3OX coverage?**
```
genome_size = 1000000
desired_coverage = 30
read_length = 100
num_reads = int((genome_size * desired_coverage)/read_length)
```

300,000 100 bp reads are required 

### Produce a 1D array (genome_coverage_30X) with 1 million positions and a zero at every position
```genome_coverage_30X = numpy.zeros(1000000, dtype= int)```

**In your simulation, how much of the genome has not been sequenced (has 0x coverage)?**
4 positions were not sequenced 
**How well does this match Poisson expectations? How well does the normal distribution fit the data?**
The Poisson estimate would be 0.0000000936 unsequenced nucleotides and the normal distribution predicts 0.0214 unsequenced nucleotides, so both distributions underestimate the number of missed nucleotides (though not by much). In general, Poisson slightly underestimates the actual coverage, while the normal distribution overestimates it.  

### Simulate sequencing 30X coverage of a 1 millon bp genome
**1. Use NumPy's pseudo-random number generator function to choose an integer between 0 and 999,900 to serve as our start position**
**2. Calculate the end position that corresponds to the randomly calculated start position**
**3. Take our array with a 0 at every position and add 1 to every value between the start and end position and save that as the new value**
**Repeat this process for all 300,000 simulated reads**
```
for i in range(300000):
    startpos = numpy.random.randint(0,999900)
    endpos = startpos + 100 
    genome_coverage_30X[startpos:endpos] += 1
```

**4. Save the coverage for each position in the genome as a text file**
```numpy.savetxt('genome_coverage_30X.csv', genome_coverage_30X, fmt='%d', delimiter=',')```

**5. Look within the genome coverage array and find the position with the highest value, which has been "sequenced" the most**
```maxcoverage_30X = numpy.max(genome_coverage_30X)``

**6. Define 0 as the lower bound of coverages observed and the upper bound is the maximum coverage observed for any position in the array + 1**
```xs_30 = list(range(0, maxcoverage_30X+1))``` 

### Calculate probability functions
**1. Calculate the Poisson probability mass function**
**In a poisson distribution, the x-axis is k (the number of occurrences), λ is the expected rate of occurrences, and the y axis is the probability of k occurrences given λ**
***In our case, we want to calculate the likelihood of getting any coverage level between 0 and our max for any particular position, with an average coverage of 3X**
```poisson_results_30X = scipy.stats.poisson.pmf(xs_30, 10)```

**2. Calculate the normal distribution probability density function**

```normal_estimates_30X = scipy.stats.norm.pdf(xs_30, loc = 10, scale = math.sqrt(10))```

**3. Save the results as text files**

```numpy.savetxt('poisson_results_10X.csv', poisson_results, fmt='%.8e', delimiter=',')```
```numpy.savetxt('normal_estimates_10X.csv', normal_estimates, fmt='%.8e', delimiter=',')```

## Exercise 2: De Bruijn graph construction

## Step 2.1 

###
```reads = ['ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 'TCATT', 'TCTTA', 'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT']```

**Write code to find all of the edges in the de Bruijn graph corresponding to the provided reads using k = 3 (assume all reads are from the forward strand, no sequencing errors, complete coverage of the genome). Each edge should be of the format ATT -> TTC. Write all edges to a file, with each edge as its own line in the file.**

**OK so in a de Bruijn graph, edges are the line segments that connect nodes**

**Here is the pseudocode**
graph = set()

for each read:
  for i in range(len(read) - k):
     kmer1 = read[i: i+k]
     kmer2 = read[i+1: i+1+k]
     add "kmer1 -> kmer2" to graph

for each edge in graph:
   print edge

**Oh wait, they are giving us the .dot file**

## Step 2.2 
```
conda create -n graphviz -c conda-forge graphviz
conda activate graphviz
```
**I had to delete the pre-existing graphviz environment that was loaded on my computer already**

## Step 2.4
```dot -Tsvg edges.dot > ex2_digraph.svg```
**Why does it specify a directed graph so frequently when all de Brujin graphs are directed? Am I missing something?**
**I cannot open it if I save it as .png, but the .svg looks normal?**

## Step 2.5
**Assume that the maximum number of occurrences of any 3-mer in the actual genome is five. Using your graph from Step 2.4, write one possible genome sequence that would produce these reads. Record your answer in your README.md.**

**Here is one version where the maximum number of occurences for any 3-mer is 3**
TTC TCT CTT TTA TAT ATT TTG TGA GAT ATT TTC TCA CAT ATT TTT 

## Step 2.6
**In a few sentences, what would it take to accurately reconstruct the sequence of the genome?**
We would need to know how many times each 3-mer occurs. Just based on the de Brujin graph, this could be highly-repetitive genome of indeterminate length, or it could visit each node the minimum number of times required to solve the graph. My guess is that if you knew how many repeats there were of each k-mer, there are some de Brujin graphs that only have one solution, and some that have only a few solutions, but at minimum it would narrow the options down! 