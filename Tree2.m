
main;

function main
    
    %point = [0, 0, 0];
    
    
    % PseudoGlobal replacement:
    
    % General
    screen = 0; % Screen characters.
    screenColour = 0; % Screen colours. The "2" is foreground, background in that order.
    screenWidth = 0;
    screenHeight = 0;
    origin = [0, 0, 0]; % Origin of tree on screen
    barkNum = 0; % The bark palette used.
    leafNum = 0; % The leaf palette used.
    
    currentChain = [SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint, SettingsPoint]; % List of settings for each segment of branch.
    
    totalBranches = 0; % Counter for the number of branches, for indexing purposes.
    
    branches = []; % Pointer to an array of Branch-es.
    
    % Colours
    reset = 0;
    barkPalettes = 0;
    leafPalettes = 0;
    bold = 0;
    faint = 0;
    italic = 0;
    underline = 0;
    doubleUnderline = 0;
    
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
        
        %currentChain = [];
        
        %branches = [];
        
        
        
        
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
        
        
        
        % generateBranch(originBranch.parent, origin, maxBranchChain);
		generateBranch(1, origin, maxBranchChain);
        
        
        
        % DISPLAY TREE HERE!
		% Actually, do it piecemeal as branches and leaves are added.
		% This should make it run a little better.
        
        
        
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
		disp(branchSettings)
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
		lastAFG = 0;
        lastCA = 0;
        lastCL = 0;
        
        for i = 10:-1:1
            
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
			angle = 0;
		end
		
    end
    
	% Generates angleFromGround setting.
    function angle = genAngleFromGround(i, angleFromGround, periodic, previous, last)
		
		% First branch (the trunk) should be straight up.
		if i == 9
			angle = 0;
			return;
		end
		
		angle = 0;
		
		% 0: random, 1: Generally upward-pointing, 2: generally horizontal/flat, 3: changes every few branches, 4: gradually changes from first to last branch
		switch angleFromGround
			case 0
				angle = randAngle(135);
			case 1
				angle = randAngleAvgAvg(135);
			case 2
				angle = randAngle(2);
				if angle > 0
					angle = randAngleAvgAvg(135) + 135;
					if angle > 135
						angle = 135;
					end
				else
					angle = randAngleAvgAvg(135) - 135;
					if angle < -135
						angle = -135;
					end
				end
			case 3
				if periodic <= 0
					periodic = randVal(6) + 1;
					angle = randAngle(135);
				else
					angle = previous;
					periodic = periodic - 1;
				end
			case 4
				if periodic == 0
					angle = randAngle(135);
					last = randAngle(135);
					periodic = angle;
				else
					angle = ((periodic * i) + (last * (10 - i))) / 10;
				end
			otherwise
		end
		
		previous = angle;
		
		if i == 9
			angle = 0;
		end
		
    end
    
    function count = genChildCount(i, childAmount, periodic, previous, last)
		
		childCount = 1;
		
		% 0: all random, 1: based off first branch, 2: changes every few branches, 3: gradually changes from first to last branch
		% Options: 1 branch, 2 branches, 3 branches
		switch childAmount
			case 0
				childCount = randVal(3) + 1;
			case 1
				if i == 9
					childCount = randVal(3) + 1;
				else
					childCount = previous;
				end
			case 2
				if periodic <= 0
					periodic = randVal(6) + 1;
					childCount = randVal(3) + 1;
				else
					childCount = previous;
					periodic = periodic - 1;
				end
			case 3
				if periodic == 0
					childCount = randVal(3) + 1;
					last = randVal(3) + 1;
					periodic = childCount;
				else
					childCount = ((periodic * i) + (last * (10 - i))) / 10;
				end
			otherwise
		end
		
		if childCount < 2
			childCount = 2;
		elseif childCount > 3
				childCount = 3;
		end
		% childCount = 3
		
		previous = childCount;
		
		count = childCount;
		
    end
    
	function position = genChildLocations(i, childLocations, periodic, previous, last)
		
		childLocation = 0;
		
		switch childLocations
			case 0
				childLocation = randVal(2);
			case 1
				if i == 9
					childLocation = randVal(2);
				else
					childLocation = previous;
				end
			case 2
				if periodic <= 0
					periodic = randVal(6) + 1;
					childLocation = randVal(2);
				else
					childLocation = previous;
					periodic = periodic - 1;
				end
			otherwise
		end
		
		if childLocation ~= 0 && childLocation ~= 1
			childLocation = 0;
		end
		
		position = childLocation;
		
    end
    
    
	
	
	
	
	
    % Generates both angleFromParent and angleFromGround, as they partially depend on eachother.
    function angles = genAngles(maxBranchChain, parent, branchNumber)
		
		% No clue why they always seem to lean to the right.
		
		% angleFromParent, angleFromGround
		angles = [0, 0];
		% angleFromParent = 0;
		% angleFromGround = 0;
		
		posOrNeg = randAngle(2);
		
		%branches
		%parent
		
		if size(branches) == 0
			angles = [0, 0];
			return;
		end
		
		if branches(parent).parent == 0
			% angleFromParent = 0;
			% angleFromGround = 0;
			angles = [0, 0];
			return;
		else
			posOrNeg = (mod(branchNumber, 2) * 2) - 1;
		end
		
		initialFromParent = currentChain(maxBranchChain).currentAngleFromPrevBranch;
		initialFromGround = currentChain(maxBranchChain).currentAngleFromGround;
		
		angleFromParent = (initialFromParent * posOrNeg) + randAngle(5) + (initalFromGround / 10);
		angleFromGround = branches(parent).angleFromGround + angleFromParent;
		
		angles = [angleFromParent, angleFromGround];
		
    end
    
    function point = genPointAlongBranch(maxBranchChain, br, start, length)
		
		pointAlongBranch = 0;
		
		switch currentChain(maxBranchChain).currentChildLocations
			case 0 % End of branch
				pointAlongBranch = length;
			case 1 % Along branch
				pointAlongBranch = randAngle(length) + 1;
			otherwise
				pointAlongBranch = length;
		end
		
		point = getEndpoint(br, start, pointAlongBranch);
		
    end
    
    function point = getEndpoint(br, start, length)
		
		angle = ((br.angleFromGround + 90) * pi) / 180;
		
		vector = [length * cos(angle), length * sin(angle)];
		
		endPoint = [start(1) + vector(1), start(2) + vector(2) / 1.2];
		
		point = endPoint;
		
    end
    
    
    function angle = randVal(range) % Generates a random value within a range.
		
		angle = randi(range) - 1;
		
	end
	
    function angle = randAngle(range) % Generates an angle within a range of plus-or-minus "range"
		
		angle = (randi(range * 2) - range) - 1;
		
	end
	
    function angle = randAngleAvg(range1, range2) % Generates an angle that is the average of randAngle(range1) & randAngle(range2)
		
		angle1 = randAngle(range1);
		angle2 = randAngle(range2);
		
		angle = (angle1 + angle2) / 2;
		
	end
	
    function angle = randAngleAvgAvg(range) % Generates an angle within a range of plus-or-minus "range", that is weighted with a rough bell curve, effectively.
		
		angle1 = randAngleAvg(range, range);
		angle2 = randAngleAvg(range, range);
		
		angle = (angle1 + angle2) / 2;
		
    end
    
    
    
    
    
    
    
    
end





