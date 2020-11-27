function output=AMF(input, diam,thresh)
if nargin < 2|| isempty(diam)
    diam=3;
end
if nargin < 3 || isempty(thresh)
    thresh=2;
end
if mod(diam,2)==0
    error('The diameter of filter should be odd !')
end
input=padarray(input,[(diam-1)/2,(diam-1)/2,0],'pre');
input=padarray(input,[(diam-1)/2,(diam-1)/2,0],'pos');
[M,N,K]=size(input);
output=input;
for z=1:K
    for i=1:M-diam+1
        for j=1:N-diam+1
            c=input(i:i+diam-1,j:j+diam-1,z);
            e=c(:);
            if output(i+(diam-1)/2,j+(diam-1)/2,z)>thresh*median(e)
                output(i+(diam-1)/2,j+(diam-1)/2,z)=median(e);
            end
        end
    end
end
output=output((diam-1)/2+1:end-(diam-1)/2,(diam-1)/2+1:end-(diam-1)/2,:);
