function imwrite8bitstack(stack, filename)
im = Tiff(filename, 'w');
infostruct.ImageLength = size(stack, 1);
infostruct.ImageWidth = size(stack, 2);
infostruct.Photometric = Tiff.Photometric.MinIsBlack;
infostruct.BitsPerSample =8;
infostruct.SampleFormat = Tiff.SampleFormat.UInt;
infostruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
for k = 1:size(stack, 3)
    im.setTag(infostruct)
    im.write(uint8(255*stack(:, :, k)));
    im.writeDirectory();
end
im.close();
end