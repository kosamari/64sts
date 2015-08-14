{
  var limit = 64;

  function CastOnError(message) {
    this.message  = message;
    this.name     = "CastOnError";
  }

  function LengthError(message) {
    this.message  = message;
    this.name     = "LengthError";
  }

  function LoopError(message) {
    this.message  = message;
    this.name     = "LoopError";
  }

  function decodePattern(lines){
    var chunks = []
    lines.map(function(line){
      if(Array.isArray(line) && line[0].length>0){
        chunks.push(line)
      }
    })

    var string = '';
    chunks.map(function(chunk){
      if(chunk.length===1){
        string += chunk[0].join('');
        if(string.length > limit){
          throw new LengthError('Length of the pattern exceeds '+limit+' stitches');
        }
      }else{
        var space = limit - (string.length + chunk[1]);
        if(space % chunk[0].length === 0){
          for(var i = 0; i < space / chunk[0].length; i++){
            string += chunk[0].join('');
          }
        }else{
          throw new LoopError('Not enough space for loop, check when to end loop');
        }
      }
    });
    return string;
  }

  function castonPattern(co, p){
    if(co > limit || co < 1){
      throw new CastOnError('CO must be between 0 - '+limit);
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
        str += '_';
      }
    }
    return {pattern:str.trim(),length:p.length, padded:j};
  }
}

start    = caston
caston   = '\n'* (comment '\n'*)* space 'CO' space co:integer p:pattern {
  return castonPattern(co, decodePattern(p))
}

pattern  = lines:line*
line     = delimiter space data:(comment / repeat / sts) {return data}

comment  = '//' txt {return '//'}
sts      = sts:['_''*']* space {return [sts]}

repeat   = sts:['_''*']+ space 'until' space endat:endat {return [sts, endat]}
endat    = end / e:integer space 'sts remain' {return e}
end      = 'end' {return 0}

integer  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }
txt      = [ -~]*
space    = ' '*
delimiter=  ',' / '\n'