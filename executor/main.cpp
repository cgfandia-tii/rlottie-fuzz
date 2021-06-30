#include <rlottie.h>
#include <rlottie_capi.h>
#include <rlottiecommon.h>

#include <string>
#include <stdexcept>
#include <iostream>
#include <vector>
#include <cstdint>

#include <stdio.h>
#include <signal.h>
#include <unistd.h>


int main(int argc, char** argv) {
    try {
        if (argc != 2)
            throw std::logic_error("No unput file!");
        const std::string input_file = argv[1];

        std::unique_ptr<rlottie::Animation> animation = 
                        rlottie::Animation::loadFromFile(input_file);
        if (!animation)
            throw std::logic_error("Cannot load file!");

        // get the frame rate of the resource. 
        double frameRate = animation->frameRate();

        // get total frame that exists in the resource
        size_t totalFrame = animation->totalFrame();

        // get total animation duration in sec for the resource 
        double duration = animation->duration();

        size_t width, height;
        animation->size(width, height);
        std::vector<uint32_t> buffer(width * height, 0x41);
        rlottie::Surface surface(buffer.data(), width, height, width);

        for (size_t i = 0; i < animation->totalFrame(); i++) {
            animation->renderSync(i, surface);
        }
        
        std::cerr << "[+] Parse file success!" << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "[-] ERROR: " << e.what() << std::endl;
    }
    return 0;
}