Math.RAD2DEG = 57.295780;
Math.DEG2RAD = 0.017453;
Math.RadianToDegree = function (Radian)
{
    return(Math.RAD2DEG * Radian);
};
Math.DegreeToRadian = function (Degree)
{
    return(Math.DEG2RAD * Degree);
};
//high speed square root approximation.
Math.inv_pow = function(root,power){
 return Math.pow(root,1/power);
};

//trace(Math.pow(3,4)); // 81
//trace(Math.inv_pow(81,4)); // 3
