#!/usr/bin/env python
#Create sentences to insert in the game source

def main():
	print("Example sentence: The apple is eaten by him (subject + verb + other complements)")
	sentences = ''

	while True:
		subject = raw_input("Insert the subject: ")
		correct_verb = raw_input("Insert the correct verb: ")
		complements = raw_input("Insert the other complements: ")

		for i in range(1, 4):
			exec('wrong_verb%d = raw_input("Insert the %d wrong verb: ")' % (i, i));

		#list.add(new Sentence("subject", "complements", "correct verb", "wrong verb 1", "wrong verb 2", "wrong verb 3"));
		sentences += 'list.add(new Sentence("%s", "%s", "%s", "%s", "%s", "%s");\n' % (subject, complements, correct_verb, wrong_verb1, wrong_verb2, wrong_verb3);

		again = raw_input("Do you want to add another sentence? ")
		if (again in ("no", "n")):
			break

	print(sentences);


if __name__ == '__main__':
	main()
