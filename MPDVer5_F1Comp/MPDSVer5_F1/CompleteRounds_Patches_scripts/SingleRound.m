
%-------------------------Complete Round Train - save - test

cd ('C:\Amr\Master\MasterCurrent\Master27-1-2017\MPDSVer4\MPDTrainModule')
MPDTrainFullPath
save('train_200images_1500features')
cd ('C:\Amr\Master\MasterCurrent\Master27-1-2017\MPDSVer4\MPDTestModule')
path = 'C:\Amr\Master\MasterCurrent\Master27-1-2017\TestVectors';
folder  = 'TestVector150-train200-1500features';
MPDTestFullPath(path,folder,1,150,'DestinationPath');

%-------------------------End Complete Round Train - save - test
