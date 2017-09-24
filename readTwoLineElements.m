%% readTwoLineElements
function [ satellite ] = readTwoLineElements( fileName, satelliteName ) 
% READTWOLINEELEMENTS read in a file of two-line elements and return data
% for a satellite
%   Usate: 
%       [satellite] = readTwoLineElements('fileName.txt', 'satelliteName');
%   Inputs: 
%       fileName: the absolute or relative path to txt file with TLE data
%       satelliteName: case-insensitive name of satellite
%   Output:
%       satellite: struct with key value pairs holding data 
    
    fileID = fopen(fileName, 'r');
    % Count number of times we find a match. 
    numMatches = 0;  
    
    while (~feof(fileID))
        line = fgets(fileID);
        % if satelliteName exists in line
        if (size(regexpi(line, satelliteName), 2) > 0)
            line1 = fgets(fileID);
            line2 = fgets(fileID);
            % Parse these 3 lines and return as a struct
            satellite = twoLine(line, line1, line2);
            numMatches = numMatches + 1;
        end
    end
    
    if (numMatches > 1) 
        warning(['%d matches for two-line elements were found for name "%s" \n' ...
         'Check that the value returned is correct or provide a more precise name.\n'],...
         numMatches, satelliteName);
    end
end


%% twoLine
function [ satellite ] = twoLine( name, line1, line2 )
%TWOLINE Convert a two line function to its individual components
%  	Usage:
%       [name, satellite_1, sattelite_2] = twoLine(name, line1, line2);
%   Inputs:
%       name: 
%           "A 24 character name (to be consistent with the name length
%           in the NORAD SATCAT)" from http://celestrak.com/NORAD/documentation/tle-fmt.asp
%       sattelite_1: 
%           A struct with key value pairs that match the values in the link
%           above
%       sattelite_2: 
%           Another struct with key value pairs that match those within the
%           link above
%   Outputs:
%       name: 
%           The same name you input.
%       line1:
%           The first line of the two-line element
%       line2:
%           The second line of the two-line element 

% Verify input
len1 = size(line1, 2);
len2 = size(line2, 2);

if (len1 <= 69)
   error('Length of line1 should be 69, but is %d', len1);
elseif (len2 <= 69)
   error('Length of line2 should be 69, but is %d', len2);
end

checkSumIndex = 69;
checksum(1, line1, checkSumIndex);
checksum(2, line2, checkSumIndex);

% Parse strings
satellite = struct;

satellite.Name                              = name;
satellite.Number                            = str2double(line1( 3:  7));
satellite.Classification                    = isClassified(line1(8));
satellite.InternationalDesignator_Year      = str2double(line1(10: 11));
satellite.InternationalDesignator_Launch    = str2double(line1(12: 14));
satellite.InternationalDesignator_Piece     = line1(15: 17);
satellite.EpochYear                         = str2double(line1(19: 20));
satellite.EpochDay                          = str2double(line1(21: 32));
satellite.FirstTimeDerivativeOfMeanMotion   = considerNegativeValue(line1(34: 43));
satellite.SecondTimeDerivativeOfMeanMotion  = line1(45: 52);
satellite.BSTARDragTerm                     = line1(54: 61);
satellite.EphemerisType                     = str2double(line1(63: 63));
satellite.ElementNumber                     = str2double(line1(65: 68));

if (str2double(line2(3: 7)) ~= satellite.Number)
    error('Satellite number from line 1 does not match line 2:\n %d does not equal %d', satellite.number, line2(3:7));
end

satellite.Inclination                       = str2double(line2( 9: 16));
satellite.RightAscensionOfAscendingNode     = str2double(line2(18: 25));
satellite.Eccentricity                      = str2double(['0.', line2(27: 33)]);
satellite.ArgumentOfPerigee                 = str2double(line2(35: 42));
satellite.MeanAnomaly                       = str2double(line2(44: 51));
satellite.MeanMotion_RevsPerDay             = str2double(line2(53: 63));
satellite.RevolutionNumberAtEpoch_Revs      = str2double(line2(64: 68));

end


%% isClassified %%
function [ classification ] = isClassified ( charArr ) 
    if (charArr(1) == 'U')
        classification = 'Unclassified';
    else
        classification = 'Classified';
    end
end


%%
function [ number ] = considerNegativeValue ( str )
% GETTIMEDERIVATIVEOFMEANMOTION include the +/- sign in the conversion to
% number
    m = size(str, 2);
    
    number = str2double(str(2: m));
    
    if (str(1) == '-')
        number = number * -1;
    end
end


%% checkSum %%
function [ ] = checksum ( lineNumber, lineStr, checksumIndex ) 
    
    sum = 0;
    
    for i = 1 : checksumIndex - 1 
        numArray = str2num(lineStr(i));
        
        if (size(numArray) > 0)
            num = numArray(1);
        elseif (lineStr(i) == '-')
            num = 1;
        else 
            num = 0;
        end
        
        sum = sum + num;
    end
    
    checksum = str2num(lineStr(checksumIndex));
    
    if (checksum ~= mod(sum, 10))
       error('Line %d did not pass the checksum \nChecksum: %d, Sum mod 10: %d, sum: %d', lineNumber, checksum, mod(sum, 10), sum); 
    end
    
end

