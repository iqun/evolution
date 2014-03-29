Codon {
	var <>signature, <>arguments, <>id;

	*new {|type|
		^super.new.init(type);
    }

	init {|type|
		signature = type;
		arguments = [];
	}

	*create {|type, depth=0|
		var root, candidates;
		candidates = Archive.global.at(\codons).select({|codon| codon.at(\return) == type});
		(depth <= 0).if({candidates = candidates.select({|codon| codon.at(\arguments).size == 0})});
		("create called, type is "+type+"candidates is "+candidates).postln;
		root = Codon(candidates.choose);
		("create setting arguments, root.signature is " + root.signature).postln;
		root.arguments = root.signature.at(\arguments).collect({|argType| Codon.create(argType, depth - 1)});
		^root;
	}

	*cull {|habitats, population=100|
		var alive;

		// cull organisms from specified habitats, limited by population
		habitats.do({|habitatId|
			var habitat = Archive.global.at(\habitats).at(habitatId);
			habitat.order({|a,b| a.value > b.value}).drop(population).do({|delenda|
				habitat.removeAt(delenda);
			});
		});

		// remove organisms that don't have habitats
		alive = Archive.global.at(\habitats).values.collect({|d| d.keys}).reduce({|a, b| a | b});
		(Archive.global.at(\organisms).keys - alive).do({|delenda|
			Archive.global.at(\organisms).removeAt(delenda);
		});
	}

	clone {|habitats, rate=0.1|
		(1.0.rand < rate).if({
			// return a perfect clone of something else or a newly created organism
			var partner = Archive.global.at(\habitats).at(habitats.choose).keys.choose;
			var validSet = Archive.global.at(\organisms).at(partner).valid(signature.at(\return));
			var swapped = (validSet.size > 0).if({validSet.choose}, {Codon.create(signature.at(\return), 5.rand)});
			^swapped;
		}, {
			// create new node with imperfectly cloned children
			var root = Codon(signature);
			root.arguments = arguments.collect({|child| child.clone(habitats, rate)});
			^root;
		});
	}

	valid {|type|
		var validSet = arguments.collect({|a| a.valid(type)}).reduce({|a, b| a | b});
		(validSet == nil).if({validSet = Set()});
		(signature.at(\return) == type).if({validSet.add(this)});
		^validSet;
	}

	insert {
		id = Array.fill(32, {0x10.rand.asHexString(1)}).join; // standard guid is 32 hex digits
		Archive.global.at(\organisms).put(id, this);
	}

	delete {
		Archive.global.at(\organisms).removeAt(id);
		Archive.global.at(\habitats).values.do({|habitat| habitat.removeAt(id)});
	}

	value {
		^signature.at(\function).valueArray(arguments.collect({|argument| argument.value()}));
	}

	judge {|judgements|
		judgements.keys.do({|key|
			var habitat = Archive.global.at(\habitats).at(key);
			var habitats = Archive.global.at(\habitats).put(key, (habitat == nil).if({(habitat=Dictionary[])}, {habitat}));
			var fitness = habitat.at(id);
			fitness = (fitness == nil).if({judgements.at(key)}, {0.8 * fitness.asFloat + (0.2 * judgements.at(key).asFloat).asFloat});
			habitat.put(id, fitness);
		});
	}

	post {|depth=""|
		(depth + signature.at(\id) + signature.asString).postln;
		arguments.do({|argument| argument.post(depth + "   ")});
	}
}
