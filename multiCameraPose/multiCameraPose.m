function [posesWrtModel] = multiCameraPose(workingDir, queryInd, cameraPoseWrtHoloLensCS, ...
                                            correspondences2D, correspondences3D, ...
                                            inlierThreshold, numLoSteps, ...
                                            invertYZ, pointsCentered, undistortionNeeded, params)
    dataDir = workingDir;
    mkdirIfNonExistent(dataDir);
    matchesDir = fullfile(dataDir, 'matches');
    mkdirIfNonExistent(matchesDir);
    rigPath = fullfile(dataDir, 'camerasIntrinsicsAndExtrinsics.txt');
    outputPath = fullfile(dataDir, 'multiCameraPoseOutput.txt');

    %% save cameras intrinsics and extrinsics, in the MultiCameraPose format
    sensorSize = params.camera.sensor.size; % height, width
    imageWidth = sensorSize(2);
    imageHeight = sensorSize(1);

    rigFile = fopen(rigPath, 'w');
    k = size(queryInd,1); % the length of the sequence
    for i=1:k
        % intrinsics
        queryId = queryInd(i);
        fprintf(rigFile, '%d PINHOLE %d %d %f %f %f %f ', queryId, imageWidth, imageHeight, ...
                                                            params.camera.K(1,1), params.camera.K(2,2), ...
                                                            params.camera.K(1,3), params.camera.K(2,3));

        % extrinsics
        thisCameraPoseWrtHoloLensCS = squeeze(cameraPoseWrtHoloLensCS(i,:,:));
        thisOrientation = thisCameraPoseWrtHoloLensCS(1:3,1:3);
        thisOrientation = thisOrientation'; % aka holoLensCSBasesToCameraBases

        thisOrientation = rotm2quat(thisOrientation); % this is the same as below code, provided 'point' is used
        %thisOrientation = quaternion(thisOrientation, 'rotmat', 'point'); % NOTE: assuming 'frame' is not the correct param
        %[A,B,C,D] = parts(thisOrientation);
        %thisOrientation = [A,B,C,D];

        thisPosition = thisCameraPoseWrtHoloLensCS(1:3,4);
        fprintf(rigFile, '%f %f %f %f %f %f %f\n', thisOrientation, thisPosition);
    end
    fclose(rigFile);

    %% save 2D-3D correspondences
    for i=1:k
        queryId = queryInd(i);
        matchesPath = fullfile(matchesDir, sprintf('%d%s', queryId, '.individual_datasets.matches.txt'));
        matchesFile = fopen(matchesPath, 'w');
        nMatchesPerQuery = size(correspondences3D,3);
        for j=1:nMatchesPerQuery
            fprintf(matchesFile, '%f %f %f %f %f\n', correspondences2D(:,j), correspondences3D(i,:,j));
        end
        fclose(matchesFile);
    end

    %% call MultiCameraPose exe
    command = sprintf('"%s" "%s" "%s" %f %d %d %d %d %d "%s"', params.multiCameraPoseExe.path, rigPath, outputPath, ...
                        inlierThreshold, numLoSteps, ...
                        invertYZ, pointsCentered, undistortionNeeded, k, matchesDir);
    disp(command);
    [status, cmdout] = system(command);
    disp(cmdout);
    
    %% load results
    fid = fopen(outputPath, 'r');
    data_all = textscan(fid, '%s', 'Delimiter', '\n');
    data_all = data_all{1};
    fclose(fid);

    posesWrtModel = zeros(k,4,4);
    for i=1:k
        stringCells = strsplit(data_all{i});
        doubleCells = str2double(stringCells);
        queryId = doubleCells(1);
        assert(queryId == queryInd(i));
        q = doubleCells(2:5); % World bases to camera bases
        t = doubleCells(6:end)'; % translation from camera origin to World origin, wrt camera bases/CS
        R = rotmat(quaternion(q), 'point'); % World bases to camera bases
        c = -R' * t; % camera origin, wrt World CS
        pose = eye(4);
        pose(1:3,1:3) = R;
        pose(1:3,4) = c;
        posesWrtModel(i,:,:) = pose;
    end
    
    %% delete temporary files
    %TODO: rmdir(dataDir, 's');
    
 end
