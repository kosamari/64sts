{
  var limit = 64;

  function decodePattern(chunks){
    var string = '';
    chunks.map(function(chunk){
      if(Array.isArray(chunk)){
        var space = limit - (string.length + chunk[1]);
        if(space % chunk[0].length === 0){
          for(var i = 0; i < space / chunk[0].length; i++){
            string += chunk[0];
          }
        }else{
          throw new Error('Length of pattern exceeds limit');
        }
      }else if(string.length < limit){
        string += chunk;
      }else{
        throw new Error('Length of pattern exceeds limit');
      }
    });
    return string;
  }

  function castonPattern(co, p){
    if(co > limit || co < 1){
      throw new Error('CO out of range');
    }
    var mod = p.length % co;
    var re = (p.length - mod) / co;
    var str = '';
    for(var i = 0; i < re; i++){
      str += p.substr(i * co, co) + '\n';
    }
    if(mod !== 0){
      str += p.substr(-mod);
      for(var j = 0; j < (co - mod); j++){
        str += '0';
      }
    }
    return str.trim();
  }
}

start    = caston

caston   = 'CO' space co:integer comma nl p:pattern space nl {
  return castonPattern(co, p)
}

pattern  = chunks:chunk+ { return decodePattern(chunks); }
chunk    = comma space s:stitches { return s }
stitches = repeat / stitch

repeat   = rset:rset+ 'until' space endat:integer space 'sts remain' {
  return [rset.join(''), endat]
}

rset     = stitch:stitch space { return stitch }

stitch   = [0-1]
integer  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }

comma    = ','?
space    = ' '*
nl       = '\n'*