pragma solidity >= 0.4.0 < 0.7.3;

contract Lottery{
    address public owner ;
    uint number; 
    bool pause = false ;
    mapping(uint => address)  AddressofLotteryParticipants;
    mapping(address => uint)  NumberofEther; 
    
    
constructor() public {
        owner = msg.sender; 
        number = 0; 
    }
    
    function BuyTickets()public Ispause One payable {
        require(msg.value >= 1 ether, "You require atleast 1 ether for participation");
        number = number + 1 ; 
        AddressofLotteryParticipants[number] = msg.sender;
        NumberofEther[msg.sender] = msg.value; 
    }
    function ChooseWinner() public Ispause OnlyOwner {
        uint number = Random();
        while(number == 0){
          number = Random();
         }
         address to = AddressofLotteryParticipants[number];
         address payable winner = payable(to);
         winner.transfer(address(this).balance);
         
        }
        
    function Random() public OnlyOwner Ispause returns (uint) {
     uint Winner = uint(keccak256(abi.encodePacked(now,block.difficulty,msg.sender)))% (number + 1 );
        return Winner;
    }
    
    function Pause()public OnlyOwner {
        if(pause == false){
           pause = true; 
        }
        else{
            pause = false;
        }
    }
    
    function Destroy()public OnlyOwner Ispause (){
     address payable to  = msg.sender;
     selfdestruct(to);
    }
    
    function Reset() public OnlyOwner Ispause {
            while(number > 100){
                NumberofEther[AddressofLotteryParticipants[number]] = 0 ether ;
                number = number - 1;
        }
        
        
 }
     
    
    modifier OnlyOwner() {
        require(msg.sender == owner, "Only owner can perform this operation") ;
        _;
    }
    modifier Ispause(){
        require(pause == false , "No more tickets issuing");
        _;
    }
    modifier One(){
        require(NumberofEther[msg.sender] < 1 ether , "Customer already registered");
        _;
    }
    
}
