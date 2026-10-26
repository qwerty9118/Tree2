
main;

function main
    
    %point = [0, 0, 0];
    
    
    % PseudoGlobal replacement:
    
    % General
    screen; % Screen characters.
    screenColour; % Screen colours. The "2" is foreground, background in that order.
    screenWidth;
    screenHeight;
    origin = [0, 0, 0]; % Origin of tree on screen
    barkNum = 0; % The bark palette used.
    leafNum = 0; % The leaf palette used.
    
    currentChain = [SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint]; % List of settings for each segment of branch.
    
    totalBranches = 0; % Counter for the number of branches, for indexing purposes.
    
    branches = []; % Pointer to an array of Branch-es.
    
    % Colours
    reset;
    barkPalettes;
    leafPalettes;
    bold;
    faint;
    italic;
    underline;
    doubleUnderline;
    
    % End of PseudoGlobal
    
    
    
    runTree();
    
    
    
    
    
    function runTree()
        
        maxBranchChain = 6;
        
        branchLength = 0;
        
        angleFromPrevBranch = 1;
		
		angleFromPrevBranchHoriz = 1;
        
        angleFromGround = 2;
        
        childAmount = 0;
        
        childLocations = 0;
        
        branchColour = 0;
        leafColour = 0;
        
        
        
        
        origin = [0, 0, 0];
        
        currentChain = [];
        
        branches = [];
        
        
        
        
        generateSettingsList(currentChain, maxBranchChain, branchLength, angleFromPrevBranch, angleFromPrevBranchHoriz, angleFromGround, childAmount, childLocations);
        
        barkNum = branchColour;
        leafNum = leafColour;
        
        
        
        originBranch = Branch;
        originBranch.parent = 0;
        originBranch.length = 0;
        originBranch.angleFromParent = 0;
        originBranch.angleFromGround = 0;
        originBranch.childCount = 1;
        originBranch.children = [];
        originBranch.pointsAlongBranch = [];
        
        
        
        generateBranch(originBranch.parent, origin, maxBranchChain);
        
        
        
        % DISPLAY TREE HERE!
        
        
        
    end
    
    
    
    
    
    
    function output = getInput(maxOpts)
        output = 0;
    end
    
    
    function newBranch = generateBranch(parent, start, maxBranchChain)
        
        totalBranches = totalBranches + 1;
        branchNumber = totalBranches;
        
        
        branchSettings = currentChain(maxBranchChain);
        
        
        newBranch = Branch;
        
        newBranch.parent = parent;
        newBranch.length = branchSettings.currentBranchLength + randVal(3) - 1;
        angles = genAngles(maxBranchChain, parent, branchNumber);
        newBranch.angleFromParent = angles(1);
        newBranch.angleFromGround = angles(2);
        newBranch.childCount = branchSettings.currentChildAmount;
        
        newBranch = genPointsAlongBranch(newBranch, maxBranchChain, start);
        
        branches(end+1) = newBranch;
        
        writeBranchToScreen(newBranch, start) % <- probably don't need? Maybe?
        % Actually, this might indeed be more efficient to write the graph lines to screen here than to go through them again at the end...
        
        if maxBranchChain > 0
            for i = 1:newBranch.childCount
                generateBranch(branchNumber, newBranch.pointsAlongBranch(i), maxBranchChain - 1);
            end
        else
            for i = 1:newBranch.childCount
                % Make leaves here!
            end
        end
        
        % Return?
    end
    
    
    function writeBranchToScreen(br, start)
        % yeah
    end
    
    function newBranch = genPointsAlongBranch(newBranch, maxBranchChain, start)
        
        newBranch.pointsAlongBranch(1) = getEndpoint(newBranch, start, newBranch.length);
        
        for i = 1:newBranch.childCount
            newBranch.pointsAlongBranch(i+1) = genPointAlongBranch(maxBranchChain, newBranch, start, newBranch.length);
        end
        
    end
    
    
	
	
	
	function generateSettingsList(currentChain, maxBranchChain, branchLength, angleFromPrevBranch, angleFromPrevBranchHoriz, angleFromGround, childAmount, childLocations)
        
        periodicBL = 0;
        periodicAFPB = 0;
        periodicAFG = 0;
        periodicCA = 0;
        periodicCL = 0;
        
        previousBL = 0;
        previousAFPB = 0;
        previousAFG = 0;
        previousCA = 0;
        previousCL = 0;
        
        lastBL = 0;
        lastAFPB = 0;
        lastCA = 0;
        lastCL = 0;
        
        for i = 10:1
            
            newSP = SettingsPoint;
            
			newSP.currentBranchLength = genLength(i, branchLength, periodicBL, previousBL, lastBL);
			newSP.currentAngleFromPrevBranch = genAngleFromPrevBranch(i, angleFromPrevBranch, periodicAFPB, previousAFPB, lastAFPB);
			%newSP.currentAngleFromPrevBranchHoriz = genAngleFromPrevBranchHoriz(i, angleFromPrevBranchHoriz, periodicAFPBH, previousAFPBH, lastAFPBH);
			newSP.currentAngleFromPrevBranchHoriz = 0;
			newSP.currentAngleFromGround = genAngleFromGround(i, angleFromGround, periodicAFG, previousAFG, lastAFG);
			newSP.currentChildAmount = genChildCount(i, childAmount, periodicCA, previousCA, lastCA);
            newSP.currentChildLocations = genChildLocations(i, childLocations, periodicCL, previousCL, lastCL);
            
            currentChain(i) = newSP;
            
        end
        
    end
    
    
	% int genLength(PseudoGlobal * pg, int maxBranchChain) {
	% i: the branch we're on
	% branchLength: the setting for the length of the branches.
	% periodic: the counter for changing every few branches.
	% previous: the previous branches output.
    function length = genLength(i, branchLength, periodic, previous, last)
		
		% 0: all random, 1: based off first branch, 2: changes every few branches, 3: changes gradually from first to last branch
		switch branchLength
			case 0
				length = randVal(5) + 3;
			case 1
				if i == 9
					length = randVal(5) + 3;
				else
					length = previous;
				end
			case 2
				if periodic <= 0
					periodic = randVal(6) + 1;
					length = randVal(5) + 3;
				else
					length = previous;
					periodic = periodic - 1;
				end
			case 3
				if periodic == 0
					length = randVal(5) + 3;
					last = randVal(5) + 3;
					periodic = length;
				else
					length = ((periodic * i) + (last * (10 - i))) / 10;
				end
			otherwise
				length = 1;
		end
		
		if length < 1
			length = 1;
		end
		
		previous = length;
		
		if i > 7
			length = randVal(5) + 10;
		end
		
    end
    
	% Generates angleFromParent setting.
    function angle = genAngleFromPrevBranch(i, angleFromPrevBranch, periodic, previous, last)
		
		angleSpread = 30;
		
		% First branch (the trunk) should be straight up.
		if i == 9
			angle = 0;
			return;
		end
		
		angle = 0;
		
		% 0: all random, 1: based off first sub-branch, 2: based off of previous branch, 3: changes every few branches, 4: changes gradually from first to last branch
		switch angleFromPrevBranch
			case 0
				angle = randAngle(angleSpread);
			case 1
				if i == 8
					angle = randAngle(angleSpread);
				else
					angle = previous;
				end
			case 2
				if i == 8
					angle = randAngle(angleSpread);
				else
					angle = previous + randAngleAvg(10, 10);
				end
			case 3
				if periodic <= 0
					periodic = randVal(6) + 1;
					angle = randAngle(angleSpread);
				else
					angle = previous;
					periodic = periodic - 1;
				end
			case 4
				if periodic == 0
					angle = randAngle(angleSpread);
					last = randAngle(angleSpread);
					periodic = angle;
				else
					angle = ((periodic * i) + (last * (10 - i))) / 10;
				end
			otherwise
		end
		
		previous = angle;
		
		if i == 9
			angle =
		
    end
    
    function angle = genAngleFromGround(i, angleFromGround, periodic, previous, last)
    end
    
    function count = genChildCount(i, childAmount, periodic, previous, last)
    end
    
    function positions = genChildLocations(i, childLocations, periodic, previous, last)
    end
    
    
    % Generates both angleFromParent and angleFromGround, as they partially depend on eachother.
    function angles = genAngles(maxBranchChain, parent, branchNumber)
    end
    
    function point = genPointAlongBranch(maxBranchChain, br, start, length)
    end
    
    function point = getEndpoint(br, start, length)
    end
    
    
    function val = randVal(range) % Generates a random value within a range.
    end
    function angle = randAngle(range) % Generates an angle within a range of plus-or-minus "range"
    end
    function angle = randAngleAvg(range1, range2) % Generates an angle that is the average of randAngle(range1) & randAngle(range2)
    end
    function angle = randAngleAvgAvg(range) % Generates an angle within a range of plus-or-minus "range", that is weighted with a rough bell curve, effectively.
    end
    
    
    
    
    
    
    
    
end
