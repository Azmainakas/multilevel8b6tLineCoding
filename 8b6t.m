% designing the lookup table
data = [0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 1;
        0 0 0 0 0 0 1 0;
        0 0 0 0 0 0 1 1;
        0 0 0 0 0 1 0 0;
        0 0 0 0 0 1 0 1;
        0 0 0 0 0 1 1 0;
        0 0 0 0 0 1 1 1;
        0 0 0 0 1 0 0 0;
        0 0 0 0 1 0 0 1;
        0 0 1 0 0 0 1 0]

symbolRep = [-1 1 0 0 -1 1; 0 -1 1 -1 1 0; 0 -1 1 0 -1 1; 0 -1 1 1 0 -1;
 -1 1 0 1 0 -1; 1 0 -1 -1 1 0; 1 0 -1 0 -1 1; 1 0 -1 1 0 -1;
 -1 1 0 0 1 -1; 0 -1 1 1 -1 0; -1 1 0 -1 1 1]

% takeing input data 
inputData = [0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 1]
organisedInpData = reshape(inputData, 8, [])'

%mapping the input data with lookup table
for i=1:size(organisedInpData,1)
 RowIdx= find(ismember(data,[organisedInpData(i,:)], 'rows')) 
 out= symbolRep(RowIdx, :)
 if i==1
  outMat= out
 end
 if i>1
  outMat = [outMat;out]
 end
end
% Remaining Work
% Weight Measurement
for x=1:size(outMat,1) 
 weight=0
 for y=1:size(outMat,2)
 weight = weight + outMat(x,y)
 end
 weightMat(x)= weight
end

% Checking 2 consequence of serial 1 for dc balancing

for j=2:size(outMat,1) 
 if weightMat(j-1)==1 && weightMat(j)==1
  for b=1:size(outMat,2)
   outMat(j,b)=(-1)*outMat(j,b)
  end
 end
end


actualMapRes = reshape(outMat',[],1)'
% For Better Representation
if actualMapRes(end)==1
    actualMapRes(1, end + 1)=1
elseif actualMapRes(end)==-1
    actualMapRes(1, end + 1)=-1
else
    actualMapRes(1, end + 1)=0
end

stairs(actualMapRes, 'LineWidth', 2);
line(xlim(),[0,0],'LineWidth', 0.1, 'Color', 'k')
axis([1 length(actualMapRes) -2 2])
ak = 2.2
for k=1:size(outMat,1)
    text(ak,-1.5,num2str(outMat(k,:)))
    ak = ak + 6 %2->8->14
end
text(2.3,1.5,'0 0 0 0 0 0 0 1')
text(8,1.5,'0 0 0 0 0 1 0 0')
text(14,1.5,'0 0 0 0 0 1 1 1')
% xline(7,'--')
xline(7,'--','LineWidth',1);
xline(13,'--','LineWidth',1);
% xline([7,13],':')
title('Encoded output')
xlabel('Time');
ylabel('Output signal')
