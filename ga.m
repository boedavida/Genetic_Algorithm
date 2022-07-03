% Executive script for running a genetic algorithm to solve the 
% knapsack problem

% Genetic algorithm includes
% 1. Recombination by crossing over between two parents
% 2. Mutation with user-specified probability
% 3. Fitness function for determining the probability that individuals 
%    will be selected for the next generation
% A parent is chosen for recombination with probability proportional
% to its fitness.
% How the population of the next generation is chosen: 

% Integer bounded knapsack problem parameters
% For the 0/1-Knapsack problem, simply set maxInt = 1
nObjs = 5;
maxInt = 3; % Integer
objWts    = [1 2 3 4 5]; 
objVals = [1 2 3 4 5];
maxKnapsackWt = 31;

% Genetic algorithm parameters
nPop = 20; % even number
nGens = 100;
mutProb = 0.01; 
RecombFlag = 1;
popChromosomes = randi(maxInt+1,[nPop,nObjs]) - 1;
fitnessScore = zeros(nPop,1);
evolving = 1; 
ithGen = 0;

while evolving
	% Increment the generation counter
	ithGen = ithGen + 1;
	
	% Fitness function -------------------------------------------------------------------
	% Determine weight of the load in the knapsack
	objWtsPop = repmat(objWts,[nPop,1]);
	knapsackWt = sum(objWtsPop.*popChromosomes,2);

	% Determine the value of the load in the knapsack
	objValsPop = repmat(objVals,[nPop,1]);
	knapsackValue = sum(objValsPop.*popChromosomes,2);

	% Find those that meet the weight limit 
	% Assign fitness score
	% Weights over the limit get a fitness score of 0
	fitnessScore(knapsackWt <= maxKnapsackWt) = knapsackValue(knapsackWt <= maxKnapsackWt);
	fitnessScore(knapsackWt > maxKnapsackWt) = 0;

	% Fitness score stats
	aveFitnessScore(ithGen) = mean(fitnessScore);
	maxFitnessScore(ithGen) = max(fitnessScore);
	relFitness = fitnessScore/(sum(fitnessScore)+eps);
	relFitness = relFitness(:).';
	% Percent with max fitness score
	percMaxFitnessScore(ithGen) = sum(fitnessScore == max(fitnessScore))/nPop;
	
	if ithGen > 1
		diffAveFitnessScore(ithGen) = aveFitnessScore(ithGen) - aveFitnessScore(ithGen-1); 
		diffMaxFitnessScore(ithGen) = maxFitnessScore(ithGen) - maxFitnessScore(ithGen-1); 	
	else
		diffAveFitnessScore(ithGen) = 0; 
		diffMaxFitnessScore(ithGen) = 0; 			
	end
	
	% Either terminate or make the next generation -------------------------------------------
	% Termination criteria: # generations, small change in 
	% either maximum fitness score or average fitness score, ...
	if ithGen ~= nGens % || (percMaxFitnessScore(ithGen) > 0.8)
			
		% Make roulette wheel for choosing parents for the next generation
		rouletteWheel = [0 cumsum(relFitness)];
		
		% Initialize the chromosomes of the next generation
		popChromosomesNextGen = zeros(size(popChromosomes));
			
		for k = 1:(nPop/2) % It takes two to tango. Get two offspring from two parents for each iteration.
			
			% Choose two parents randomly with probability proportional to fitnessScore
			% Choose first parent
			n = rand(1);
			parent1 = find(rouletteWheel < n,1,'last');
			
			% Choose the second parent. Can't be the first parent.
			parent2 = parent1;
			while parent2 == parent1
				n = rand(1);
				parent2 = find(rouletteWheel < n,1,'last');
			end
				
			if RecombFlag
				% Crossing over
				crPnt = randi(nObjs-1,1);
				popChromosomesNextGen(2*k-1,:) = [popChromosomes(parent1,1:crPnt), popChromosomes(parent2,crPnt+1:end)];
				popChromosomesNextGen(2*k,:) = [popChromosomes(parent2,1:crPnt), popChromosomes(parent1,crPnt+1:end)];
			else
				popChromosomesNextGen(2*k-1,:) = popChromosomes(parent1,:);
				popChromosomesNextGen(2*k,:) = popChromosomes(parent2,:);
			end				
		end

		% Mutation
		zerosOnes = rand01(mutProb,nPop,nObjs);
		popChromosomesNextGen(zerosOnes == 1) = randi(maxInt+1,[1,sum(sum(zerosOnes))]) - 1;

		% The next generation becomes the current generation
		popChromosomes = popChromosomesNextGen;
	else
		evolving = 0;
	end	
end

% Get the best answer
[~,maxIdx] = max(fitnessScore);
mostFit = popChromosomes(maxIdx,:);
popChromosomes
fitnessScore
combinatorial = popChromosomes(maxIdx,:)
knapsackWght = sum(objWts.*mostFit)
knapsackValue = sum(objVals.*mostFit)

figure, plot(maxFitnessScore), grid on
xlabel('Generation')
ylabel('Max. fitness score')
title('Maximum fitness score vs. generation')
figure, plot(aveFitnessScore), grid on
title('Average fitness score vs. generation')
xlabel('Generation')
ylabel('Ave. fitness score')

