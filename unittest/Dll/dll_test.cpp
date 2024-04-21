#include <gtest/gtest.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <dlfcn.h>
#endif
#include <string>

#define DLL_NAME L"libSample"

std::string wstr2str(const std::wstring &wstr)
{
    if (wstr.empty())
        return "";
    std::string str(wstr.begin(), wstr.end());
    return str;
}

class Dll
{
    private:
        void* h; // win version: HINSTANCE h

    public:
        Dll(const std::wstring &filename) : h(
                #ifdef _WIN32
                LoadLibrary(wstr2str(filename).c_str())
                #else
                dlopen(wstr2str(filename).c_str(), RTLD_LAZY)
                #endif
            ) {}
        ~Dll() 
        {
            if (h) {
                #ifdef _WIN32
                FreeLibrary((HINSTANCE)h);
                #else
                dlclose(h);
                #endif
            }
        }

        void* GetH() const 
        {
            if (h == nullptr) {
                #ifdef _WIN32
                throw std::to_string(GetLastError());
                #else
                throw std::string(dlerror());
                #endif
                return nullptr;
            }
            return (void *)h;
        }

        //win version: FARPROC GetProc(HINSTANCE h, const char* procName)
        void *GetProcedure(const std::wstring &procName) const
        {
            #ifdef _WIN32
            return (void *)GetProcAddress((HINSTANCE)h, wstr2str(procName).c_str());
            #else
            return dlsym(h, wstr2str(procName).c_str());
            #endif
        };
};

TEST(DllTest, LoadDll) {
    std::wstring dllName = DLL_NAME;

    #ifdef _WIN32
    dllName += L".dll";
    #else
    dllName = L"bin/Debug/" + dllName + L".so";
    #endif
    Dll h(dllName);
    EXPECT_TRUE(h.GetH());
    
    typedef long long int (*GetVersionFunction)();
    const GetVersionFunction GetVersion = reinterpret_cast<GetVersionFunction>(h.GetProcedure(L"GetVersion"));
    EXPECT_TRUE(GetVersion != nullptr);
    EXPECT_EQ(GetVersion(), 1);
}
