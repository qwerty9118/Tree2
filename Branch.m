classdef Branch
	%BRANCH Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
		parent
		
		length
		angleFromParent
		angleFromGround
		
		%angleFromParentHoriz
		
		childCount
		children = []
		pointsAlongBranch = []
	end
	
end

