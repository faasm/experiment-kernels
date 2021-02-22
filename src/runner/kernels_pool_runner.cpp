#include <faabric/util/logging.h>

#include <faaslet/FaasletPool.h>

#include <faabric/endpoint/FaabricEndpoint.h>
#include <faabric/executor/FaabricMain.h>

#include <map>
#include <stdlib.h> /* atoi */

using namespace faabric::executor;
using namespace faaslet;

std::map<std::string, std::string> prk_cmdline = {
    { "dgemm", "10 500 32 1" },
    { "nstream", "10 2000000 0" },
    { "random", "16 16" }, 
    { "reduce", "10 2000000" },
    { "sparse", "10 10 4" },
    { "stencil", "10 1000" },
    { "global", "10 10000" },
    { "p2p", "10 1000 100" },
    { "transpose", "10 2000 64" },
};

int main(int argc, char* argv[])
{
    faabric::util::initLogging();
    const std::shared_ptr<spdlog::logger>& logger = faabric::util::getLogger();
    faabric::util::SystemConfig& conf = faabric::util::getSystemConfig();

    // Get function from cmdline and set the right cmdline
    if (argc < 3) {
        throw std::runtime_error(
                "usage: ./kernels_pool_runner.cpp <func> <np>"
        );
    }
    std::string func = argv[1];
    int np = atoi(argv[2]);
    std::string cmdline = prk_cmdline[func];

    // Set up the message
    auto msg = faabric::util::messageFactory("prk", func);
    msg.set_cmdline(cmdline);
    msg.set_mpiworldsize(np);
    logger->info("Running function prk/random");

    // Set up the scheduler
    faabric::scheduler::Scheduler& sch = faabric::scheduler::getScheduler();
    sch.addHostToGlobalSet();

    // Start the worker pool
    logger->info("Starting faaslet pool in the background");
    FaasletPool pool(5);
    pool.startThreadPool();

    // Run LAMMPS
    sch.callFunction(msg);

    // Await the result
    const faabric::Message& result =
      sch.getFunctionResult(msg.id(), conf.globalMessageTimeout);
    if (result.returnvalue() != 0) {
        logger->error("Execution failed: {}", result.outputdata());
        throw std::runtime_error("Executing function failed");
    }

    // Shutdown thread pool
    pool.shutdown();

    return EXIT_SUCCESS;
}
