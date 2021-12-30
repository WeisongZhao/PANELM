function FRCMap = fSNR_stack(stack,params)

if nargin == 1
    %-------image property----------
    params.pixelSize = 0.0325;
    params.boundaryintensity = 5;%0~255
    %-----------tSNR----------------
    % drift para
    params.driftCorrection = false;
    % FRC map para
    params.blocksize = 64;
    params.skip = 1;
    params.enableSingleFrame = false;
    % output para
    params.boundary = true;
    params.IF_adaptive_boundary = false;
    params.amedianfilter = true;
    params.interpolation = false;
end

% avoid error
if params.skip >1
    params.amedianfilter = false;
end
if mod(params.blocksize,2)~=0
    params.blocksize = params.blocksize + 1;
end
[ox,oy,~]=size(stack);
if params.enableSingleFrame
    stacklarge = stack;
    clear stack
    stack(:,:,1)=stacklarge(1:2:end,1:2:end);
    stack(:,:,2)=stacklarge(2:2:end,2:2:end);
    stack(:,:,3)=stacklarge(1:2:end,2:2:end);
    stack(:,:,4)=stacklarge(2:2:end,1:2:end);
    FRCMap=zeros([size(stack,1) * 2,size(stack,2) * 2],'single');
else
    FRCMap=zeros([size(stack,1),size(stack,2)],'single');
end
stack=single(stack);
if params.IS3D == 0
    stack=normalize(stack);
end

%% drift correstion
if params.driftCorrection
    params.roiRadius = 5;
    params.maxIterations = 200;
    [~ , Shift] = DriftDetect (stack(:,:,1), stack(:,:,2), ...
        'maxIterations', params.maxIterations, 'roiRadius', params.roiRadius);  %Find shift
    [xF,yF] = meshgrid(-floor(ox/2):-floor(ox/2)+ox-1,-floor(oy/2):-floor(oy/2)+oy-1); %Define shift in frequency domain
    fftB = fftshift(fft2(stack(:,:,2)));
    fftB = fftB.*exp(-1i*2*pi.*((-xF*Shift(1))/ox+(-yF*Shift(2))/oy))+eps; %Perform the shift
    B = abs(real(ifft2(ifftshift(fftB))));
    stack(:,:,2) = B./max(max(B));
    fprintf(strcat('', 'SubPixel Shift:', '\n', ...
        num2str(Shift(1)),' pixels in x;' , '\n', ...
        num2str(Shift(2)),' pixels in y.', '\n' ));
    if params.enableSingleFrame
        [~ , Shift] = DriftDetect (stack(:,:,3), stack(:,:,4), ...
            'maxIterations', params.maxIterations, 'roiRadius', params.roiRadius);  %Find shift
        [xF,yF] = meshgrid(-floor(ox/2):-floor(ox/2)+ox-1,-floor(oy/2):-floor(oy/2)+oy-1); %Define shift in frequency domain
        fftB = fftshift(fft2(stack(:,:,4)));
        fftB = fftB.*exp(-1i*2*pi.*((-xF*Shift(1))/ox+(-yF*Shift(2))/oy))+eps; %Perform the shift
        B = abs(real(ifft2(ifftshift(fftB))));
        stack(:,:,4)=B./max(max(B));
        fprintf(strcat('', 'SubPixel Shift:', '\n', ...
            num2str(Shift(1)),' pixels in x;' , '\n', ...
            num2str(Shift(2)),' pixels in y.', '\n' ));
    end
end

%% fSNR(FRC) map estimation
if params.enableSingleFrame
    if params.mapping0143
        [xv,yv,v] = fSNRmap0143(stack(:,:,1:2),params);
    else
        [xv,yv,v] = fSNRmap(stack(:,:,1:2),params);
    end
    v(v<1000 * params.pixelSize*2.3) = 1000 * params.pixelSize * 2.3;
    [xv2,yv2,v2] = fSNRmap(stack(:,:,3:4),params);
    v2(v2<1000 * params.pixelSize*2.3) = 1000 * params.pixelSize * 2.3;
    FRCM = zeros(ox/2,oy/2,'single');
    FRCM2 = zeros(ox/2,oy/2,'single');
    FRCMl = zeros(ox,oy,'single');
    for i = 1:length(v)
        FRCM(round(xv(i)),round(yv(i)))=v(i);
    end
    for i = 1:length(v2)
        FRCM2(round(xv2(i)),round(yv2(i)))=v2(i);
    end
    FRCM2(FRCM2==0) = FRCM(FRCM2==0);
    FRCM(FRCM==0) = FRCM2(FRCM==0);
    FRCM = (FRCM+FRCM2)/2;
    FRCMl(1:2:end,1:2:end) = FRCM;
    FRCMl(1:2:end,2:2:end) = FRCM;
    FRCMl(2:2:end,1:2:end) = FRCM;
    FRCMl(2:2:end,2:2:end) = FRCM;
    FRCM=FRCMl;
else
    if params.mapping0143
        [xv,yv,v]=fSNRmap0143(stack,params);
    else
        [xv,yv,v]=fSNRmap(stack,params);
    end
    v(v<1000 * params.pixelSize * 2.3) = 1000 * params.pixelSize * 2.3;
    FRCM=zeros(ox,oy,'single');
    for i=1:length(v)
        FRCM(round(xv(i)),round(yv(i)))=v(i);
    end
end
%% output
FRCMap = FRCM;

if params.amedianfilter
    FRCMap =AMF(FRCMap);
end