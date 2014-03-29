/*
This project is a dirt simple evolutionary programming system that stores and evolves functional organisms.  Organisms are composed of atomic functional units represented by Codon object instances.  Archive.sctxar is a data file that captures the ongoing state of evolutionary progress, and should be mapped to your default SuperCollider archive file.  Evolutionary data is captured in three categories of data that exist as keys of the global Archive object:


\codons
A map of basic functional units used to construct organisms in the ecosystem

\organisms
A map of all extant organisms in the ecosystem, referenced by unique identifier

\habitats
A map of collections of organisms.  The extent to which an organism is able to thrive in each habitat is captured here.  Each habitat is identified by a descriptive term which should be used to determine an organism's fitness in the context of that habitat.


By convention, all randomness is seeded with the global variable r.  Each organism, then, will correspond to a family of functions whose behavior can be reliably reproduced with some established value of r.
*/


// Show a summary of evolutionary state
("SUMMARY\nOrganisms:" + Archive.global.at(\organisms).size).postln;
("Codons:" + Archive.global.at(\codons).size).postln;
("Habitats:" + Archive.global.at(\habitats).size).postln;
Archive.global.at(\habitats).keysValuesDo({|key, value| ("\t" + key ++ ":" + value.keys.size).postln;});"";

// Display all codons
Archive.global.at(\codons).do({|codon| codon.at(\id).postln;(("\t") + codon.at(\return)).postln;(("\t") + codon.at(\arguments)).postln;(("\t") + codon.at(\function).def.sourceCode).postln;});"";

// Show the this codon and all descendent nodes
c.post;

// Show event codon stream
p = c.arguments.at(0).value();
p.next;
q = p.asStream;
10.do({q.next.postln});'done';

// Add a codon (argument and return types must be explicitly defined)
Archive.global.at(\codons).put(\fractal, Dictionary[
	\id -> \fractal,
	\function -> {|p,d| (d <= 0).if({0}, {Pseq(p + Array.fill(p.size, thisFunction.value(p, d - 1)))})},
	\arguments -> [Array.class.asString, Integer.class.asString],
	\return -> Pattern.class.asString,
]);



/*
Evolution happens in three stages: Creation or mutation of new organisms, testing of fitness, and population culling.  New organisms can either be created randomly, or cloned from existing organisms with a specified mutation rate, within the context of a certain subset of habitats.
*/


// Create new event codon of a given depth
c = Codon.create(Event.class.asString, 5);c.post;

// Clone a node at the default mutation rate
c.clone([\melodic]);

// Insert the new organism into the ecosystem
c.insert;

// The value function walks the organism tree to create the root node object
c.value().play;

// Judge the fitness of an organism (this, in conjunction with the value function form the testing stage)
c.judge(Dictionary[\dark -> 2, \light -> 5, \melodic -> 5, \rhythmic -> 7, \interesting -> 3]);

// Survival of the fittest
Codon.cull([\rhythmic], 2);