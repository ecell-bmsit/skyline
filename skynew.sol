// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Flights {
    struct Flight {
        string id;
        string image;
        string name;
        string model;
        Logs[] logs;
        mapping (string => string) maintenance;
    }

    struct Maintenance {
        string id;
        string fuelCapacity;
        string engineStatus;
        string safety;
        string atcR;
        string emission;
        string time;
    }

    struct Logs {
        string id;
        string details;
        string duration;
        string blackBox;
        string fuelConsum;
    }

    Flight[] public flightArray;

    // Add this function to get the flight index
    function getFlightIndex(string memory _sid) internal view returns (uint8) {
        for (uint8 i = 0; i < flightArray.length; i++) {
            if (keccak256(abi.encodePacked(flightArray[i].id)) == keccak256(abi.encodePacked(_sid))) {
                return i;
            }
        }
        revert("Flight not found");
    }

    function addFlights(string memory _image, string memory _name, string memory _model, string memory _id) external {
        Flight storage newFlight = flightArray.push();
        newFlight.image = _image;
        newFlight.name = _name;
        newFlight.model = _model;
        newFlight.id = _id;
    }

    function addLogs(
        string memory _id,
        string memory _details,
        string memory _duration,
        string memory _blackBox,
        string memory _fuelConsum
    ) public {
        uint8 _index = getFlightIndex(_id);
        Flight storage currentFlight = flightArray[_index];
        Logs memory newLog;
        newLog.details = _details;
        newLog.duration = _duration;
        newLog.blackBox = _blackBox;
        newLog.fuelConsum = _fuelConsum;
        currentFlight.logs.push(newLog);
    }

    function addMaintenance(
        string memory _id,
        string memory _fuelCapacity,
        string memory _engineStatus,
        string memory _safety,
        string memory _atcR,
        string memory _emission,
        string memory _time
    ) public {
        uint8 _index = getFlightIndex(_id);
        Flight storage currentFlight = flightArray[_index];
        currentFlight.maintenance["fuelCapacity"] = _fuelCapacity;
        currentFlight.maintenance["engineStatus"] = _engineStatus;
        currentFlight.maintenance["safety"] = _safety;
        currentFlight.maintenance["atcR"] = _atcR;
        currentFlight.maintenance["emission"] = _emission;
        currentFlight.maintenance["time"] = _time;
    }

    // Get only Flight details
    function getFlightDetails(string memory _sid) external view returns (
        string memory, string memory, string memory, string memory
    ) {
        uint8 _index = getFlightIndex(_sid);
        Flight storage currentFlight = flightArray[_index];
        return (
            currentFlight.image, currentFlight.name, currentFlight.model, currentFlight.id
        );
    }

    // Get all Maintenance records for a flight
    function getAllMaintenanceDetails(string memory _sid) external view returns (
        string memory, string memory, string memory, string memory, string memory, string memory
    ) {
        uint8 _index = getFlightIndex(_sid);
        Flight storage currentFlight = flightArray[_index];
        return (
            currentFlight.maintenance["fuelCapacity"],
            currentFlight.maintenance["engineStatus"],
            currentFlight.maintenance["safety"],
            currentFlight.maintenance["atcR"],
            currentFlight.maintenance["emission"],
            currentFlight.maintenance["time"]
        );
    }

    // Get all Logs for a flight
    function getAllLogs(string memory _sid) external view returns (Logs[] memory) {
        uint8 _index = getFlightIndex(_sid);
        return flightArray[_index].logs;
    }
}
